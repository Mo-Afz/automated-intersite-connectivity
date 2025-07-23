# modules/virtual-machines/variables.tf

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "selected_sku" {
  description = "VM SKU/size for both VMs"
  type        = string
  validation {
    condition = can(regex("^Standard_", var.selected_sku))
    error_message = "VM SKU must start with 'Standard_'."
  }
}

variable "admin_username" {
  description = "Administrator username for the VMs"
  type        = string
  validation {
    condition = length(var.admin_username) >= 1 && length(var.admin_username) <= 64
    error_message = "Admin username must be between 1 and 64 characters."
  }
}

variable "admin_password" {
  description = "Administrator password for the VMs"
  type        = string
  sensitive   = true
  validation {
    condition = length(var.admin_password) >= 12 && length(var.admin_password) <= 123
    error_message = "Admin password must be between 12 and 123 characters."
  }
}

variable "core_services_subnet_id" {
  description = "ID of the subnet where the Core Services VM will be deployed"
  type        = string
}

variable "manufacturing_subnet_id" {
  description = "ID of the subnet where the Manufacturing VM will be deployed"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}