resource "azurerm_monitor_scheduled_query_rules_alert_v2" "kv_forbidden" {
  name                = "alert-kv-forbidden"
  resource_group_name = azurerm_resource_group.monitoring.name
  location            = azurerm_resource_group.monitoring.location
  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  severity             = 2
  scopes               = [azurerm_log_analytics_workspace.core.id]
  enabled              = true

  criteria {
    query = <<-KQL
      AzureDiagnostics
      | where Category == "AuditEvent"
      | where StatusCode == 403
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 0
  }

  display_name = "Key Vault Forbidden"
}
