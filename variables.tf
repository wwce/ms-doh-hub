
#-----------------------------------------------------------------------------------------------------------------
# VM-Series variables
variable out_fw_names {
  type        = list(string)
  description = "Enter names for the firewalls. For every name entered, an additional instance is created"
}

variable in_fw_names {
  type        = list(string)
  description = "Enter names for the firewalls. For every name entered, an additional instance is created"
}

variable fw_nsg_prefix {
  description = "This address prefix will be able to access the firewall's mgmt interface over TCP/443 and TCP/22"
}

variable dev-environment {
  default = "dev"
}

variable build-version {
}

variable vnet-type {
  
}

variable in_fw_avset_name {
}

variable out_fw_avset_name {
}

variable fw_panos {
}

variable fw_license {
  # default = "byol"   
  # default = "bundle1"  
  # default = "bundle2"
}
variable fw_vm_size {
  # default = "d"   
  # default = "bundle1"  
  # default = "bundle2"
}

variable fw_username {
}

variable fw_password {
}

variable in_fw_bootstrap_storage_account {
  description = "Azure storage account to bootstrap firewalls"
}
variable in_fw_bootstrap_access_key {
  description = "Access key of the bootstrap storage account"
}
variable in_fw_bootstrap_file_share {
  description = "Storage account's file share name that contains the bootstrap directories"
}
variable in_fw_bootstrap_share_directory {
  description = "Storage account's share directory name (useful if deploying multiple firewalls)"
}

variable out_fw_bootstrap_storage_account {
  description = "Azure storage account to bootstrap firewalls"
}
variable out_fw_bootstrap_access_key {
  description = "Access key of the bootstrap storage account"
}
variable out_fw_bootstrap_file_share {
  description = "Storage account's file share name that contains the bootstrap directories"
}
variable out_fw_bootstrap_share_directory {
  description = "Storage account's share directory name (useful if deploying multiple firewalls)"
}

variable prefix {
  description = "Prefix to prepend to newly created resources"
}

#-----------------------------------------------------------------------------------------------------------------
# Azure load balancer variables
variable public_lb_name {
}

variable internal_lb_name {
}

variable internal_lb_address {
}


variable tags {
  description = "The tags to associate with newly created resources"
  type        = map(string)

  default = {
    # tag1 = ""
    # tag2 = ""
    # trusted-resource = "yes"
    # allow-internet   = "yes"
  }
}

