output "route_table_id" {
  description = "ID of the route table"
  value       = azurerm_route_table.core_services_rt.id
}

output "route_table_name" {
  description = "Name of the route table"
  value       = azurerm_route_table.core_services_rt.name
}