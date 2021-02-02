# OUTPUTS
output "instance_public_ips" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = azurerm_linux_virtual_machine.aion.*.public_ip_address
}

output "instance_private_ips" {
  description = "List of private IP addresses assigned to the instances, if applicable"
  value       = azurerm_linux_virtual_machine.aion.*.private_ip_address
}

output "instance_ids" {
  description = "List of instance IDs"
  value       = azurerm_linux_virtual_machine.aion.*.id
}