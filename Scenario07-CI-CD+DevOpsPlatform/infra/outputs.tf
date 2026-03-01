output "log_analytics_workspace_id" {
  value = module.loganalytics.workspace_id
}

output "app_service_name" {
  value = module.appservice.app_name
}

output "key_vault_name" {
  value = module.keyvault.kv_name
}

