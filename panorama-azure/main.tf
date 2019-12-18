
data "azurerm_resource_group" "existing_vnet_rg" {
  name = "rg-networking-prod-001"
}

data "azurerm_resource_group" "existing_security_rg" {
  name = "rg-security-prod-001"
}


data "azurerm_virtual_network" "existing_vnet" {
  name = "vnet-hub-prod-001"
  resource_group_name = "rg-networking-prod-001"
}

resource "azurerm_managed_disk" "disk" {
  name                 = "panorama_logging_disk"
  location             = data.azurerm_resource_group.existing_security_rg.location
  resource_group_name  = data.azurerm_resource_group.existing_security_rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "2000"
}

data "azurerm_subnet" "panorama_mgmt_subnet" {
  name                 = "sub-hub-prod-panwmgt-001"
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_vnet_rg.name
}


resource "azurerm_network_security_group" "nsg-rama-mgt" {
  name                = "nsg-mgmt-${var.vnet-location}-${var.dev-environment}-${var.build-version}"
  location            = data.azurerm_resource_group.existing_security_rg.location
  resource_group_name = data.azurerm_resource_group.existing_security_rg.name

  security_rule {
    name                       = "mgmt-inbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "22"]
    source_address_prefix      = var.src_prefix
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

# Create public IPs for firewall's management & dataplane1 interface
resource "azurerm_public_ip" "rama-nic0-pip" {
  name                = "panorama-pip-${var.dev-environment}-${var.build-version}"
  location            = data.azurerm_resource_group.existing_security_rg.location
  resource_group_name = data.azurerm_resource_group.existing_security_rg.name
  allocation_method   = "Static"
  sku								  = "Standard"
}

#-----------------------------------------------------------------------------------------------------------------
# Create Panorama interface (mgmt, data1, data2).  Dynamic interface is created first, then IP is set statically.

resource "azurerm_network_interface" "nic0" {
  name                      = "${var.rama_name}-nic0-${var.dev-environment}-${var.build-version}"
  location                  = data.azurerm_resource_group.existing_security_rg.location
  resource_group_name       = data.azurerm_resource_group.existing_security_rg.name
  network_security_group_id = azurerm_network_security_group.nsg-rama-mgt.id

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = data.azurerm_subnet.panorama_mgmt_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.rama-nic0-pip.id
  }
}


#-----------------------------------------------------------------------------------------------------------------
# Create Panorama


resource "azurerm_virtual_machine" "panorama" {
  name                         = var.rama_name
  location                     = data.azurerm_resource_group.existing_security_rg.location
  resource_group_name          = data.azurerm_resource_group.existing_security_rg.name
  vm_size                      = var.rama_size
  primary_network_interface_id = azurerm_network_interface.nic0.id

  network_interface_ids = [
    azurerm_network_interface.nic0.id
  ]
  os_profile_linux_config {
    disable_password_authentication = false
  }

  plan {
    name      = var.pan_sku
    publisher = var.pan_publisher
    product   = var.pan_series
  }

  storage_image_reference {
    publisher   = var.pan_publisher
    offer       = var.pan_series
    sku         = var.pan_sku
    version     = var.pan_version
  }

  storage_os_disk {
    name              = "${var.rama_name}-${var.dev-environment}-osdisk-${var.build-version}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.rama_name}-${var.dev-environment}-${var.build-version}"
    admin_username = var.rama_username
    admin_password = var.rama_password
  }
}