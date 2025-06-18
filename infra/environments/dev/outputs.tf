# ==============================================================================
# 開発環境用 出力値定義
# ==============================================================================

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "frontend_app_name" {
  description = "The name of the frontend web app"
  value       = azurerm_linux_web_app.frontend.name
}

output "frontend_default_hostname" {
  description = "The default hostname of the frontend web app"
  value       = azurerm_linux_web_app.frontend.default_hostname
}

output "frontend_url" {
  description = "The URL of the frontend web app"
  value       = "https://${azurerm_linux_web_app.frontend.default_hostname}"
}

output "backend_app_name" {
  description = "The name of the backend web app"
  value       = azurerm_linux_web_app.backend.name
}

output "backend_default_hostname" {
  description = "The default hostname of the backend web app"
  value       = azurerm_linux_web_app.backend.default_hostname
}

output "backend_url" {
  description = "The URL of the backend web app"
  value       = "https://${azurerm_linux_web_app.backend.default_hostname}"
}

output "sql_server_name" {
  description = "The name of the SQL server"
  value       = azurerm_mssql_server.main.name
}

output "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL server"
  value       = azurerm_mssql_server.main.fully_qualified_domain_name
}

output "sql_database_name" {
  description = "The name of the SQL database"
  value       = azurerm_mssql_database.main.name
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_account_primary_blob_endpoint" {
  description = "The primary blob endpoint of the storage account"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "application_insights_name" {
  description = "The name of the Application Insights instance"
  value       = azurerm_application_insights.main.name
}

output "application_insights_instrumentation_key" {
  description = "The instrumentation key of Application Insights"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "application_insights_connection_string" {
  description = "The connection string of Application Insights"
  value       = azurerm_application_insights.main.connection_string
  sensitive   = true
} 