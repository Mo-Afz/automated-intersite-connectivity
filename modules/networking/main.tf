# Core Services Virtual Network
resource "azurerm_virtual_network" "core_services_vnet" {
  name                = "CoreServicesVnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]

  tags = var.tags
}

resource "azurerm_subnet" "core_subnet" {
  name                 = "Core"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.core_services_vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "perimeter_subnet" {
  name                 = "perimeter"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.core_services_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Manufacturing Virtual Network
resource "azurerm_virtual_network" "manufacturing_vnet" {
  name                = "ManufacturingVnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["172.16.0.0/16"]

  tags = var.tags
}

resource "azurerm_subnet" "manufacturing_subnet" {
  name                 = "Manufacturing"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.manufacturing_vnet.name
  address_prefixes     = ["172.16.0.0/24"]
}

# VNet Peerings
resource "azurerm_virtual_network_peering" "core_to_manufacturing" {
  name                      = "CoreServicesVnet-to-ManufacturingVnet"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.core_services_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.manufacturing_vnet.id
  
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "manufacturing_to_core" {
  name                      = "ManufacturingVnet-to-CoreServicesVnet"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.manufacturing_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.core_services_vnet.id
  
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false
}

resource "null_resource" "enable_network_watcher" {
  provisioner "local-exec" {
    command = "az network watcher configure --locations ${var.location} --enabled true"
  }

  triggers = {
    region         = var.location
    watcher_status = timestamp() # forces re-run if needed
  }
}

# Network Watcher (ensure it exists for the region)
resource "azurerm_network_watcher" "lab_network_watcher" {
  name                = "NetworkWatcher_eastus"
  location            = var.location
  resource_group_name = var.network_watcher_resource_group_name
}