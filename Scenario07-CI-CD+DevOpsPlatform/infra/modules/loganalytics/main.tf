resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-s07-monitoring"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

output "workspace_id" {
  value = azurerm_log_analytics_workspace.law.id
}

