#-----------------------------------------------------------------------------------------------------------------
# Azure environment variables
variable vnet_name {
  default = "vnet-hub-prod-001"
}

variable src_prefix {
  default = "0.0.0.0/0"
}

variable vnet_rg {
  default = "rg-networking-prod-001"
}

variable mgmt_subnet {
  default = "mgmt"
}

variable panorama_rg {
  default = "panorama-rg"
}

variable vnet-location {
  default = "spoke"
}

variable dev-environment {
  default = "dev"
}

variable build-version {
}

#-----------------------------------------------------------------------------------------------------------------
# Azure VNET variables for VM-Series

variable pan_publisher {
  default = "paloaltonetworks"
}

variable pan_sku {
  default = "byol"
}

variable  pan_series  {
  default = "panorama"
}

variable  pan_version  {
  default = "latest"
}

#-----------------------------------------------------------------------------------------------------------------
# Panorama variables
variable rama_name {
  type        = string
  description = "Enter names for Panorama."
}

variable rama_size {
  type = string
  default = "Standard_DS4_v2"
}

variable rama_nsg_prefix {
  description = "This address prefix will be able to access the firewall's mgmt interface over TCP/443 and TCP/22"
}

variable rama_license {
  default = "byol"   

}

variable rama_username {
}

variable rama_password {
}



