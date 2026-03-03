output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_id" {
  value = azurerm_subnet.web.id
}

output "nsg_id" {
  value = azurerm_network_security_group.nsg.id
}

output "app_service_plan_id" {
  value = azurerm_service_plan.asp.id
}

output "webapp_id" {
  value = azurerm_linux_web_app.webapp.id
}

output "log_analytics_id" {
  value = azurerm_log_analytics_workspace.law.id
}

output "app_insights_id" {
  value = azurerm_application_insights.appi.id
}

output "action_group_id" {
  value = azurerm_monitor_action_group.ag.id
}

output "smart_detector_id" {
  value = azurerm_monitor_smart_detector_alert_rule.smart.id
}

output "metric_alert_id" {
  value = azurerm_monitor_metric_alert.metric.id
}

output "network_watcher_id" {
  value = azurerm_network_watcher.nw.id
}
