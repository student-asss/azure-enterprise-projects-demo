resource "azurerm_monitor_scheduled_query_rules_alert_v2" "nsg_inbound_deny" {
  name                = "alert-nsg-inbound-deny"
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = azurerm_resource_group.monitoring.location
  evaluation_frequency = "PT10M"
  window_duration      = "PT10M"
  severity             = 2
  scopes               = [azurerm_log_analytics_workspace.core.id]
  enabled              = true

  criteria {
    query = <<-KQL
      AzureDiagnostics
      | where Category == "NetworkSecurityGroupEvent"
      | where direction_s == "Inbound"
      | where action_s == "Deny"
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 50
  }

  display_name = "NSG inbound deny"
}
