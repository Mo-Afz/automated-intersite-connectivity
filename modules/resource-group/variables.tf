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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}