# Custom Route Table
resource "azurerm_route_table" "core_services_rt" {
  name                = "rt-CoreServices"
  location            = var.location
  resource_group_name = var.resource_group_name

  bgp_route_propagation_enabled = false

  route {
    name                   = "PerimetertoCore"
    address_prefix         = "10.0.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = "10.0.1.7"
  }

  tags = var.tags
}

# Associate route table with Core Services subnet
resource "azurerm_subnet_route_table_association" "core_services_subnet_rt_association" {
  subnet_id      = var.core_services_subnet_id
  route_table_id = azurerm_route_table.core_services_rt.id
}