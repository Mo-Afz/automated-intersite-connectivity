terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "2aafe57c-11c3-45b8-aa48-9d7b8bc13b4c"
}

# Local values
locals {
  common_tags = {
    Environment = "Lab"
    Project     = "Azure-Lab-05"
    Lab         = "Intersite-Connectivity"
    CreatedBy   = "Terraform"
  }
}

# Resource Group Module
module "resource_group" {
  source = "../../modules/resource-group"
  
  resource_group_name = var.resource_group_name
  location           = var.location
  tags              = local.common_tags
}

# Networking Module
module "networking" {
  source = "../../modules/networking"
  
  location            = module.resource_group.resource_group_location
  resource_group_name = module.resource_group.resource_group_name
  tags               = local.common_tags
  
  depends_on = [module.resource_group]
}

# Virtual Machines Module
module "virtual_machines" {
  source = "../../modules/virtual-machines"

  location                  = module.resource_group.resource_group_location
  resource_group_name       = module.resource_group.resource_group_name
  core_services_subnet_id   = module.networking.core_services_subnet_id
  manufacturing_subnet_id   = module.networking.manufacturing_subnet_id
  selected_sku              = var.selected_sku
  admin_username            = var.admin_username
  admin_password            = var.admin_password

  tags = local.common_tags

  depends_on = [module.networking]
}

# Routing Module
module "routing" {
  source = "../../modules/routing"

  location                  = module.resource_group.resource_group_location
  resource_group_name       = module.resource_group.resource_group_name
  core_services_subnet_id   = module.networking.core_services_subnet_id

  tags = local.common_tags

  depends_on = [module.networking]
}