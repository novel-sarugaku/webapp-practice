# ==============================================================================
# 開発環境用 Terraform 設定
# ==============================================================================

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# ==============================================================================
# ローカル変数
# ==============================================================================

locals {
  environment = "dev"
  project     = "webapp"
  location    = "Japan East"
  
  common_tags = {
    Environment = local.environment
    Project     = local.project
    Owner       = "DevTeam"
    CreatedBy   = "Terraform"
  }

  # 開発環境用の設定
  config = {
    app_service_sku = "F1"  # 無料プラン
    sql_sku        = "Basic"
    backup_enabled = false
  }
}

# ==============================================================================
# リソースグループ
# ==============================================================================

resource "azurerm_resource_group" "main" {
  name     = "rg-${local.project}-${local.environment}"
  location = local.location
  tags     = local.common_tags
}

# ==============================================================================
# App Service Plan
# ==============================================================================

resource "azurerm_service_plan" "main" {
  name                = "asp-${local.project}-${local.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name           = local.config.app_service_sku
  tags               = local.common_tags
}

# ==============================================================================
# Web App (Frontend)
# ==============================================================================

resource "azurerm_linux_web_app" "frontend" {
  name                = "app-${local.project}-fe-${local.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id
  tags               = merge(local.common_tags, { Component = "Frontend" })

  site_config {
    always_on = false  # Free プランでは always_on は使用不可

    application_stack {
      node_version = "18-lts"
    }

    # CORS設定
    cors {
      allowed_origins     = ["*"]  # 開発環境では全許可
      support_credentials = false
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
    "NODE_ENV"                     = "development"
    "API_BASE_URL"                 = "https://${var.backend_app_name}.azurewebsites.net"
  }
}

# ==============================================================================
# Web App (Backend API)
# ==============================================================================

resource "azurerm_linux_web_app" "backend" {
  name                = "app-${local.project}-be-${local.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id
  tags               = merge(local.common_tags, { Component = "Backend" })

  site_config {
    always_on = false  # Free プランでは always_on は使用不可

    application_stack {
      node_version = "18-lts"
    }

    # CORS設定
    cors {
      allowed_origins = [
        "https://${azurerm_linux_web_app.frontend.default_hostname}",
        "http://localhost:3000",  # ローカル開発用
        "http://localhost:5173"   # Vite開発サーバー用
      ]
      support_credentials = true
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
    "NODE_ENV"                     = "development"
    "DATABASE_URL"                 = "Server=${azurerm_mssql_server.main.fully_qualified_domain_name};Database=${azurerm_mssql_database.main.name};User Id=${azurerm_mssql_server.main.administrator_login};Password=${var.sql_admin_password};"
    "JWT_SECRET"                   = var.jwt_secret
  }
}

# ==============================================================================
# SQL Server & Database
# ==============================================================================

resource "azurerm_mssql_server" "main" {
  name                         = "sql-${local.project}-${local.environment}"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sql_admin_password
  tags                        = local.common_tags

  # 開発環境では Azure サービスからのアクセスを許可
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_mssql_database" "main" {
  name           = "${local.project}-db"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = local.config.sql_sku
  tags          = local.common_tags
}

# SQL Server ファイアウォール設定 (開発環境用)
resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# 開発用: 全IPからのアクセスを許可 (本番環境では絶対に使用しない)
resource "azurerm_mssql_firewall_rule" "allow_all" {
  name             = "AllowAllIPs-DevOnly"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

# ==============================================================================
# Application Insights
# ==============================================================================

resource "azurerm_application_insights" "main" {
  name                = "appi-${local.project}-${local.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"
  tags               = local.common_tags
}

# ==============================================================================
# Storage Account
# ==============================================================================

resource "azurerm_storage_account" "main" {
  name                     = "st${local.project}${local.environment}"  # 小文字のみ、24文字以内
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"  # 開発環境はローカル冗長で十分
  tags                    = local.common_tags

  # 開発環境では制限を緩く設定
  allow_nested_items_to_be_public = true
  
  blob_properties {
    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS"]
      allowed_origins    = ["*"]
      exposed_headers    = ["*"]
      max_age_in_seconds = 3600
    }
  }
}

# Blob Container for file uploads
resource "azurerm_storage_container" "uploads" {
  name                  = "uploads"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "blob"  # 開発環境では public read を許可
} 