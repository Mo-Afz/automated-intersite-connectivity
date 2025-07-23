output "core_services_vm_id" {
  description = "ID of Core Services VM"
  value       = azurerm_windows_virtual_machine.core_services_vm.id
}

output "core_services_vm_name" {
  description = "Name of Core Services VM"
  value       = azurerm_windows_virtual_machine.core_services_vm.name
}

output "core_services_vm_private_ip" {
  description = "Private IP of Core Services VM"
  value       = azurerm_network_interface.core_services_vm_nic.private_ip_address
}

output "manufacturing_vm_id" {
  description = "ID of Manufacturing VM"
  value       = azurerm_windows_virtual_machine.manufacturing_vm.id
}

output "manufacturing_vm_name" {
  description = "Name of Manufacturing VM"
  value       = azurerm_windows_virtual_machine.manufacturing_vm.name
}

output "manufacturing_vm_private_ip" {
  description = "Private IP of Manufacturing VM"
  value       = azurerm_network_interface.manufacturing_vm_nic.private_ip_address
}