# Terraform + Azure 技術解説

## 1. Terraform とは

### 1.1 概要
Terraformは、HashiCorp社が開発したオープンソースのInfrastructure as Code (IaC) ツールです。宣言的な設定ファイルを使用してクラウドインフラストラクチャを定義・管理できます。

### 1.2 主な特徴
- **宣言的構文**: 最終的な状態を記述するだけで、Terraformが差分を計算
- **プラットフォーム非依存**: AWS、Azure、GCP等、複数のクラウドプロバイダーに対応
- **状態管理**: インフラの現在の状態を追跡・管理
- **プランニング**: 変更前に影響を確認可能
- **モジュール化**: 再利用可能なコンポーネントとして構成

## 2. Azure Provider

### 2.1 Azure Provider 設定
```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

### 2.2 認証方法
- **Azure CLI**: `az login` で認証
- **Service Principal**: アプリケーション登録による認証
- **Managed Identity**: Azure VM内での認証
- **Environment Variables**: 環境変数による認証

## 3. Azure Web App に必要なサービス

### 3.1 Resource Group (リソースグループ)
```hcl
resource "azurerm_resource_group" "main" {
  name     = "rg-webapp-prod"
  location = "Japan East"
  
  tags = {
    Environment = "Production"
    Project     = "WebApp"
  }
}
```

**用途**: Azure リソースの論理的なコンテナ
**料金**: 無料（リソースグループ自体に料金はかからない）

### 3.2 App Service Plan
```hcl
resource "azurerm_service_plan" "main" {
  name                = "asp-webapp-prod"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name           = "B1"
}
```

**プラン別料金** (東日本リージョン):
- **Free (F1)**: 無料 - 60分/日制限、1GBストレージ
- **Shared (D1)**: ¥1,000/月 - 240分/日制限、1GBストレージ
- **Basic (B1)**: ¥5,500/月 - 制限なし、10GBストレージ
- **Standard (S1)**: ¥7,500/月 - 自動スケール、50GBストレージ
- **Premium (P1)**: ¥15,000/月 - 高性能、250GBストレージ

### 3.3 App Service (Web App)
```hcl
resource "azurerm_linux_web_app" "main" {
  name                = "webapp-unique-name-prod"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      node_version = "18-lts"
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
  }
}
```

### 3.4 Azure SQL Database
```hcl
resource "azurerm_mssql_server" "main" {
  name                         = "sqlserver-webapp-prod"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "main" {
  name           = "webapp-db"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = "Basic"
}
```

**SQL Database 料金**:
- **Basic**: ¥500/月 - 2GB、小規模アプリ向け
- **Standard S0**: ¥1,500/月 - 250GB、中規模アプリ向け
- **Premium P1**: ¥50,000/月 - 500GB、高性能要求向け

### 3.5 Application Insights
```hcl
resource "azurerm_application_insights" "main" {
  name                = "appi-webapp-prod"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"
}
```

**料金**: 月間5GBまで無料、超過分は¥250/GB

### 3.6 Key Vault
```hcl
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                = "kv-webapp-prod"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
    ]
  }
}
```

**料金**: ¥50/月 + ¥0.03/10,000操作

### 3.7 Storage Account
```hcl
resource "azurerm_storage_account" "main" {
  name                     = "stwebappprod"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
```

**料金**: 
- **LRS (ローカル冗長)**: ¥2.5/GB/月
- **GRS (地理冗長)**: ¥5/GB/月

## 4. Terraform ベストプラクティス

### 4.1 ディレクトリ構造
```
infra/
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
├── modules/
│   └── webapp/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── shared/
    ├── backend.tf
    └── providers.tf
```

### 4.2 状態管理（Remote Backend）
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstate"
    container_name       = "tfstate"
    key                  = "webapp/prod/terraform.tfstate"
  }
}
```

### 4.3 変数管理
```hcl
# variables.tf
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Japan East"
}

variable "app_service_sku" {
  description = "App Service Plan SKU"
  type        = string
  default     = "B1"
}
```

### 4.4 タグ付け戦略
```hcl
locals {
  common_tags = {
    Environment = var.environment
    Project     = "WebApp"
    Owner       = "DevTeam"
    CostCenter  = "IT"
    CreatedBy   = "Terraform"
  }
}

resource "azurerm_resource_group" "main" {
  name     = "rg-webapp-${var.environment}"
  location = var.location
  tags     = local.common_tags
}
```

## 5. セキュリティ設定

### 5.1 Network Security Group
```hcl
resource "azurerm_network_security_group" "webapp" {
  name                = "nsg-webapp-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
```

### 5.2 Private Endpoint
```hcl
resource "azurerm_private_endpoint" "sql" {
  name                = "pe-sql-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  subnet_id           = azurerm_subnet.private.id

  private_service_connection {
    name                           = "psc-sql"
    private_connection_resource_id = azurerm_mssql_server.main.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
}
```

## 6. コスト最適化

### 6.1 環境別リソース設定
```hcl
locals {
  environment_config = {
    dev = {
      app_service_sku = "F1"
      sql_sku        = "Basic"
      backup_enabled = false
    }
    staging = {
      app_service_sku = "B1"
      sql_sku        = "S0"
      backup_enabled = true
    }
    prod = {
      app_service_sku = "S1"
      sql_sku        = "S1"
      backup_enabled = true
    }
  }
}
```

### 6.2 自動スケーリング設定
```hcl
resource "azurerm_monitor_autoscale_setting" "webapp" {
  name                = "autoscale-webapp-${var.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  target_resource_id  = azurerm_service_plan.main.id

  profile {
    name = "default"

    capacity {
      default = 2
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = azurerm_service_plan.main.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 80
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}
```

## 7. 運用コマンド

### 7.1 基本コマンド
```bash
# 初期化
terraform init

# プラン確認
terraform plan

# 適用
terraform apply

# 削除
terraform destroy

# 状態確認
terraform show
```

### 7.2 環境別デプロイ
```bash
# 開発環境
cd environments/dev
terraform init
terraform apply -var-file="terraform.tfvars"

# 本番環境
cd environments/prod
terraform init
terraform apply -var-file="terraform.tfvars"
```

---

**月額料金概算** (本番環境):
- App Service Plan (S1): ¥7,500
- SQL Database (S0): ¥1,500
- Application Insights: ¥0-250 (使用量による)
- Key Vault: ¥50
- Storage Account: ¥100-300 (使用量による)
- **合計**: 約¥10,000-12,000/月 