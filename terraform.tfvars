fw_license                   = "bundle2" #"byol" #"bundle1" 
out_fw_bootstrap_storage_account = ""
out_fw_bootstrap_access_key      = ""
out_fw_bootstrap_file_share      = ""
out_fw_bootstrap_share_directory = "None"

in_fw_bootstrap_storage_account = ""
in_fw_bootstrap_access_key      = ""
in_fw_bootstrap_file_share      = ""
in_fw_bootstrap_share_directory = "None"


# -----------------------------------------------------------------------
prefix = ""
fw_vm_size = "Standard_DS3_v2"

out_fw_names                 = ["out-vmseries-fw1", "out-vmseries-fw2"]
in_fw_names                  = ["in-vmseries-fw1","in-vmseries-fw2"]
fw_nsg_prefix                = "0.0.0.0/0"
in_fw_avset_name             = "in-fwavset"
out_fw_avset_name            = "out-fwavset"
fw_panos                     = "latest"
fw_username                  = "paloalto"
fw_password                  = "PanPassword123!"

public_lb_name               = "public-lb"
internal_lb_name             = "internal-lb"
internal_lb_address          = "172.16.96.76"


vnet-type                    = "hub"
dev-environment                  = "prod"
build-version = "001"