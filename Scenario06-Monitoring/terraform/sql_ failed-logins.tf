resource "azurerm_monitor_scheduled_query_rules_alert_v2" "sql_failed_logins" {
  name                = "alert-sql-failed-logins"
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
      | where Category == "SQLSecurityAuditEvents"
      | where action_name_s == "DATABASE_AUTHENTICATION_FAILED"
    KQL

    time_aggregation_method = "Count"
    operator                = "GreaterThan"
    threshold               = 5
  }

  display_name = "SQL failed logins"
}
