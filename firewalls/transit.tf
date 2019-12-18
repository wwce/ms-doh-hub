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

data "azurerm_subnet" "fwtrust_subnet" {
  name                 = "sub-hub-prod-fwtrust-001"
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_vnet_rg.name
}

data "azurerm_subnet" "fwuntrust_subnet" {
  name                 = "sub-hub-prod-fwuntrust-001"
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_vnet_rg.name
}

data "azurerm_subnet" "panorama_mgmt_subnet" {
  name                 = "sub-hub-prod-panwmgt-001"
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_resource_group.existing_vnet_rg.name
}

#-----------------------------------------------------------------------------------------------------------------
# Create VNET
#module "vnet" {
#  source              = "./modules/vnet/"
#  location            = var.location
#  resource_group_name = var.resource_group_name
#  vnet_name           = var.vnet_name
#  address_space       = var.vnet_cidr
#  subnet_names        = var.subnet_names
#  subnet_prefixes     = var.subnet_cidrs
#}

#-----------------------------------------------------------------------------------------------------------------
# Create VM-Series NGFW for outbound.  For every fw_name entered, an additional VM-Series instance will be deployed.
module "vmseries-out" {
  source                       = "./modules/vmseries/"
  location                     = data.azurerm_resource_group.existing_security_rg.location
  resource_group_name          = data.azurerm_resource_group.existing_security_rg.name
  fw_names                     = var.out_fw_names
  fw_username                  = var.fw_username
  fw_password                  = var.fw_password
  fw_panos                     = var.fw_panos
  fw_license                   = var.fw_license
  fw_nsg_prefix                = var.fw_nsg_prefix
  fw_avset_name                = var.out_fw_avset_name
  fw_subnet_mgmt               = data.azurerm_subnet.panorama_mgmt_subnet.id
  fw_subnet_untrust            = data.azurerm_subnet.fwuntrust_subnet.id
  fw_subnet_trust              = data.azurerm_subnet.fwtrust_subnet.id
  fw_bootstrap_storage_account = var.out_fw_bootstrap_storage_account
  fw_bootstrap_access_key      = var.out_fw_bootstrap_access_key
  fw_bootstrap_file_share      = var.out_fw_bootstrap_file_share
  fw_bootstrap_share_directory = var.out_fw_bootstrap_share_directory
  prefix                       = var.prefix
  build-version                = var.build-version
  dev-environment = var.dev-environment
}

#-----------------------------------------------------------------------------------------------------------------
# Create VM-Series NGFW for inbound.  For every fw_name entered, an additional VM-Series instance will be deployed.
module "vmseries-in" {
  source                       = "./modules/vmseries/"
  location                     = data.azurerm_resource_group.existing_security_rg.location
  resource_group_name          = data.azurerm_resource_group.existing_security_rg.name
  fw_names                     = var.in_fw_names
  fw_username                  = var.fw_username
  fw_password                  = var.fw_password
  fw_panos                     = var.fw_panos
  fw_license                   = var.fw_license
  fw_nsg_prefix                = var.fw_nsg_prefix
  fw_avset_name                = var.in_fw_avset_name
  fw_subnet_mgmt               = data.azurerm_subnet.panorama_mgmt_subnet.id
  fw_subnet_untrust            = data.azurerm_subnet.fwuntrust_subnet.id
  fw_subnet_trust              = data.azurerm_subnet.fwtrust_subnet.id
  fw_bootstrap_storage_account = var.in_fw_bootstrap_storage_account
  fw_bootstrap_access_key      = var.in_fw_bootstrap_access_key
  fw_bootstrap_file_share      = var.in_fw_bootstrap_file_share
  fw_bootstrap_share_directory = var.in_fw_bootstrap_share_directory
  prefix                       = var.prefix
  build-version                = var.build-version
  dev-environment = var.dev-environment
}



#-----------------------------------------------------------------------------------------------------------------
# Create internal load balancer. Load balancer uses firewall's trust interfaces as its backend pool
module "internal_lb" {
  source              = "./modules/lb/"
  location            = data.azurerm_resource_group.existing_security_rg.location
  resource_group_name = data.azurerm_resource_group.existing_security_rg.name
  type                = "private"
  name                = var.internal_lb_name

  probe_ports             = [22]
  frontend_ports          = [0]
  backend_ports           = [0]
  protocol                = "All"
  backend_pool_count      = length(var.out_fw_names)
  backend_pool_interfaces = module.vmseries-out.nic2_id
  subnet_id               = data.azurerm_subnet.fwtrust_subnet.id
  private_ip_address      = var.internal_lb_address
}

module "public_lb" {
  source                  = "./modules/lb/"
  location            = data.azurerm_resource_group.existing_security_rg.location
  resource_group_name = data.azurerm_resource_group.existing_security_rg.name
  type                    = "public"
  name                    = var.public_lb_name
  probe_ports             = [22]
  frontend_ports          = [80, 22, 443]
  backend_ports           = [80, 22, 443]
  protocol                = "Tcp"
  backend_pool_count      = length(var.in_fw_names)
  backend_pool_interfaces = module.vmseries-in.nic1_id
}

