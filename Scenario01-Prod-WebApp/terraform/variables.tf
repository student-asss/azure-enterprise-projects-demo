variable "location" {
  type    = string
  default = "norwayeast"
}

variable "vnet_name" {
  type    = string
  default = "vnet-s01"
}

variable "nsg_name" {
  type    = string
  default = "nsg-web"
}

variable "asp_name" {
  type    = string
  default = "asp-s01-free"
}

variable "webapp_name" {
  type    = string
  default = "webapp-s01-prod"
}

variable "workspace_name" {
  type    = string
  default = "law-s01"
}

variable "appinsights_name" {
  type    = string
  default = "appi-s01"
}

variable "action_group_name" {
  type    = string
  default = "ag-s01"
}

variable "alert_email" {
  type = string
}

variable "smart_detector_name" {
  type    = string
  default = "failure-anomalies"
}

variable "metric_alert_name" {
  type    = string
  default = "high-traffic-alert"
}

variable "network_watcher_name" {
  type    = string
  default = "NetworkWatcher_norwayeast"
}
