resource "azurerm_monitor_data_collection_rule" "vm_core_app" {
  name                = "dcr-vm-core-app"
  location            = azurerm_resource_group.monitoring.location
  resource_group_name = azurerm_resource_group.monitoring.name
  kind                = "Linux"

  destinations {
    log_analytics {
      name                 = "law-dest"
      workspace_resource_id = azurerm_log_analytics_workspace.core.id
    }
  }

  data_sources {
    syslog {
      name    = "syslog-source"
      facility_names = ["auth", "authpriv", "daemon", "kern", "syslog"]
      log_levels     = ["Error", "Critical", "Alert", "Emergency"]
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["law-dest"]
  }
}

resource "azurerm_monitor_data_collection_rule_association" "vm_core_app" {
  name                    = "dcr-assoc-vm-core-app"
  target_resource_id      = azurerm_linux_virtual_machine.vm_core_app.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.vm_core_app.id
}
