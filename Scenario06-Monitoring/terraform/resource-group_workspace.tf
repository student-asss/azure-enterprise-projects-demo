resource "azurerm_resource_group" "monitoring" {
  name     = "rg-s06-monitoring"
  location = "westeurope"
}

resource "azurerm_log_analytics_workspace" "core" {
  name                = "law-core-monitoring"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
