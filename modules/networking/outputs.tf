output "core_services_vnet_id" {
  description = "ID of Core Services VNet"
  value       = azurerm_virtual_network.core_services_vnet.id
}

output "core_services_vnet_name" {
  description = "Name of Core Services VNet"
  value       = azurerm_virtual_network.core_services_vnet.name
}

output "manufacturing_vnet_id" {
  description = "ID of Manufacturing VNet"
  value       = azurerm_virtual_network.manufacturing_vnet.id
}

output "manufacturing_vnet_name" {
  description = "Name of Manufacturing VNet"
  value       = azurerm_virtual_network.manufacturing_vnet.name
}

output "core_services_subnet_id" {
  description = "ID of the Core Services subnet (alias for core_subnet_id)"
  value       = azurerm_subnet.core_subnet.id
}

output "perimeter_subnet_id" {
  description = "ID of Perimeter subnet"
  value       = azurerm_subnet.perimeter_subnet.id
}

output "manufacturing_subnet_id" {
  description = "ID of the Manufacturing subnet"
  value       = azurerm_subnet.manufacturing_subnet.id
}

output "network_watcher_name" {
  description = "Name of Network Watcher"
  value       = azurerm_network_watcher.lab_network_watcher.name
}

output "network_watcher_id" {
  description = "ID of Network Watcher"
  value       = azurerm_network_watcher.lab_network_watcher.id
}