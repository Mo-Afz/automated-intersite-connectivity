# environments/lab/outputs.tf
output "resource_group_name" {
  description = "Name of the resource group"
  value       = module.resource_group.resource_group_name
}

output "core_services_vnet_name" {
  description = "Name of Core Services VNet"
  value       = module.networking.core_services_vnet_name
}

output "manufacturing_vnet_name" {
  description = "Name of Manufacturing VNet"
  value       = module.networking.manufacturing_vnet_name
}

output "core_services_vm_name" {
  description = "Name of Core Services VM"
  value       = module.virtual_machines.core_services_vm_name
}

output "core_services_vm_private_ip" {
  description = "Private IP of Core Services VM"
  value       = module.virtual_machines.core_services_vm_private_ip
}

output "manufacturing_vm_name" {
  description = "Name of Manufacturing VM"
  value       = module.virtual_machines.manufacturing_vm_name
}

output "manufacturing_vm_private_ip" {
  description = "Private IP of Manufacturing VM"
  value       = module.virtual_machines.manufacturing_vm_private_ip
}

output "network_watcher_name" {
  description = "Name of Network Watcher"
  value       = module.networking.network_watcher_name
}

output "route_table_name" {
  description = "Name of the custom route table"
  value       = module.routing.route_table_name
}
