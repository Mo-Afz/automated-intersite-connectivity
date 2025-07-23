# environments/lab/variables.tf
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "az104-rg5"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "vm_size" {
  description = "Size of the virtual machines"
  type        = string
  default     = "Standard_DS2_v3"
}

variable "selected_sku" {
  description = "VM SKU/size for virtual machines"
  type        = string
  default     = "Standard_B2s"
  
  validation {
    condition = can(regex("^Standard_", var.selected_sku))
    error_message = "VM SKU must start with 'Standard_'."
  }
}

variable "admin_username" {
  description = "Admin username for VMs"
  type        = string
  default     = "localadmin"
}

variable "admin_password" {
  description = "Admin password for VMs (must be complex)"
  type        = string
  sensitive   = true
  validation {
    condition = length(var.admin_password) >= 12 && can(regex("[A-Z]", var.admin_password)) && can(regex("[a-z]", var.admin_password)) && can(regex("[0-9]", var.admin_password)) && can(regex("[^A-Za-z0-9]", var.admin_password))
    error_message = "Password must be at least 12 characters long and contain uppercase, lowercase, numbers, and special characters."
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "Infrastructure"
  }
}