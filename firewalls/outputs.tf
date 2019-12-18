output "INBOUND-MGMT-FW1" {
  value = "https://${module.vmseries-in.nic0_public_ip[0]}"
}

output "INBOUND-MGMT-FW2" {
  value = "https://${module.vmseries-in.nic0_public_ip[1]}"
}

output "OUTBOUND-MGMT-FW1" {
  value = "https://${module.vmseries-out.nic0_public_ip[0]}"
}

output "OUTBOUND-MGMT-FW2" {
  value = "https://${module.vmseries-out.nic0_public_ip[1]}"
}