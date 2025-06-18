# ==============================================================================
# 開発環境用 変数定義
# ==============================================================================

variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.sql_admin_password) >= 8
    error_message = "SQL admin password must be at least 8 characters long."
  }
}

variable "jwt_secret" {
  description = "JWT secret key for token signing"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.jwt_secret) >= 32
    error_message = "JWT secret must be at least 32 characters long."
  }
}

variable "backend_app_name" {
  description = "Backend app name for API URL construction"
  type        = string
  default     = "app-webapp-be-dev"
} 