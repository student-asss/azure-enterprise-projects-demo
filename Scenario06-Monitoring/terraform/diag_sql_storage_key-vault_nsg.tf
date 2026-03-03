# 10.1 SQL server – Auditing -> Log Analytics
resource "azurerm_monitor_diagnostic_setting" "sql_core_audit" {
  name                       = "ds-sql-core-audit"
  target_resource_id         = azurerm_mssql_server.sql_core_server.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.core.id

  enabled_log {
    category = "SQLSecurityAuditEvents"
  }
}

# 10.2 Storage account – StorageRead/Write/Delete
resource "azurerm_monitor_diagnostic_setting" "stcore_logs" {
  name                       = "ds-stcore-logs"
  target_resource_id         = azurerm_storage_account.stcore.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.core.id

  enabled_log { category = "StorageRead" }
  enabled_log { category = "StorageWrite" }
  enabled_log { category = "StorageDelete" }
}

# 10.3 Key Vault – AuditEvent
resource "azurerm_monitor_diagnostic_setting" "kv_core_audit" {
  name                       = "ds-kv-core-audit"
  target_resource_id         = azurerm_key_vault.kv_core.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.core.id

  enabled_log {
    category = "AuditEvent"
  }
}

# 10.4 NSG – NetworkSecurityGroupEvent/RuleCounter
resource "azurerm_monitor_diagnostic_setting" "nsg_app_subnet" {
  name                       = "ds-nsg-app-subnet"
  target_resource_id         = azurerm_network_security_group.nsg_app_subnet.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.core.id

  enabled_log { category = "NetworkSecurityGroupEvent" }
  enabled_log { category = "NetworkSecurityGroupRuleCounter" }
}
