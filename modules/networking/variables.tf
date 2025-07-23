variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "network_watcher_resource_group_name" {
  description = "Resource group for Network Watcher"
  type        = string
  default     = "NetworkWatcherRG"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}