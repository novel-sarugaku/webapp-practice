### ⑤-1`main.tf` の記載内容の確認

`main.tf` は、Terraformで **「実際に何を作るか」** を定義するメインの構成ファイル

#### 全体の構成イメージ

```hcl
terraform {
  # Terraform 自体の設定（プロバイダーのバージョン指定など）
}

provider "azurerm" {
  # 使用するクラウドプロバイダーとして Azure を指定
  # 認証方法やリージョンなどの情報を記述
}

locals {
  # よく使う値（定数）をまとめて定義
  # 例：location = "japaneast"
}

resource "azurerm_xxx" "名前" {
  # 実際に作成する Azure リソース（VM, WebApp, DBなど）
  # xxxの部分はリソースの種類（例：azurerm_resource_group、azurerm_app_service）
}
```
#### 要素の意味

| 項目 | 意味 |
|------|------|
| `terraform` | Terraform のバージョンや、使うプロバイダーを指定するセクション |
| `provider` | Azure など、どのクラウドを使用するかを指定（例：`azurerm`） |
| `locals` | 定数のように使い回す値を定義（例：location や tags など） |
| `resource` | 実際に作成したい Azure リソースを定義（例：Web アプリ、DB） |
| `site_config`, `app_settings` | Web アプリに対する詳細な設定（アプリ設定や構成） |
| `tags` | Azure 上での管理タグ（誰が作成したか、用途などを記録） |

#### 基本構文

##### Terraform本体の設定

```hcl
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
```

| 項目 | 意味 |
|------|------|
| `required_version` | Terraform CLI のバージョン指定。例：`>= 1.0` は「バージョン 1.0 以上で実行」という意味 |
| `required_providers { ... }` | Terraform が使用するクラウドサービスのプロバイダー情報を指定するブロック |
| `azurerm = { ... }` | Azure のプロバイダーを使用することを指定 |
| `source = "hashicorp/azurerm"` | Terraform の公式プロバイダーリポジトリ（HashiCorp）から `azurerm` プロバイダーを取得する設定 |
| `version = "~> 3.0"` | 「バージョン 3.0 以上かつ 4.0 未満」を意味するバージョン指定のルール |

##### Azureに接続するためのプロバイダー設定

```hcl
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}
```

| 項目 | 説明 |
|------|------|
| `provider "azurerm"` | Azure を使用するための基本設定ブロック |
| `features {}` | プロバイダーごとの追加設定を書くためのブロック。**Azure（azurerm）では空でも記述が必須（省略不可）** |
| `key_vault {}` | Azure Key Vault に特化した設定を記述するブロック |
| `purge_soft_delete_on_destroy = true` | Key Vault を削除する際に、Azure の Soft Delete 機能をスキップし、**即時完全削除**を行う設定 |
| `recover_soft_deleted_key_vaults = true` | **ソフト削除された Key Vault を自動的に復元**する設定 |

| purge_soft_delete_on_destroyを記載する理由 | |
|------|------|
| 記載しない場合、Azure の Key Vault は削除後も最大 30 日間「Soft Delete」状態で残るため |
| 記載しない場合、同じ名前で作り直そうとすると「すでに存在している」としてエラーになるため |

##### ローカル変数の定義

```hcl
locals {
  environment = "dev"         # 開発環境
  project     = "webapp"      # プロジェクト名
  location    = "Japan East"  # Azure のリージョン

  common_tags = {             # すべてのリソースに共通して付与するタグ
    Environment = local.environment
    Project     = local.project
    Owner       = "DevTeam"
    CreatedBy   = "Terraform"
  }

  config = {
    app_service_sku = "F1"     # App Service の無料プラン
    sql_sku         = "Basic"  # SQL サーバーのプラン
    backup_enabled  = false    # バックアップ機能を無効化
  }
}
```

| 項目 | 説明 |
|------|------|
| `locals { ... }` | Terraform ファイル内で共通して使いたい値をまとめて定義するローカル変数ブロック |
| `var.〇〇` | 外部（`terraform.tfvars` や CLI 入力）から渡す変数。ユーザー指定の値 |
| `local.〇〇` | `locals` 内で定義された内部変数。このファイル内限定で使用可能 |
| `local.environment = "dev"` | 開発環境かどうかを示す値。`dev` のほかに `staging` や `prod` なども使用可 |
| `local.project = "webapp"` | プロジェクト名。リソース名などに自動的に含めて使うために定義 |
| `local.location = "Japan East"` | Azure のリージョン（ここでは東京リージョン）を指定 |
| `local.common_tags = { ... }` | Azure のリソースに共通で付けるタグ一覧。後述のタグで管理しやすくする |
| `Owner = "DevTeam"` | タグの一部：このリソースの所有者情報を表す |
| `CreatedBy = "Terraform"` | タグの一部：このリソースが Terraform により作成されたことを明示 |
| `local.config = { ... }` | 各種設定値をマップ型でまとめたもの。料金プランやオプションを集中管理 |
| `app_service_sku = "F1"` | Web アプリの料金プラン（F1 = 無料） |
| `sql_sku = "Basic"` | SQL Server の料金プラン（Basic） |
| `backup_enabled = false` | バックアップ機能を有効にするかどうかのフラグ（false = 無効） |

##### Azure でリソースグループを作成する定義

```hcl
resource "azurerm_resource_group" "main" {
  name     = "rg-${local.project}-${local.environment}"
  location = local.location
  tags     = local.common_tags
}
```

| 項目 | 説明 |
|------|------|
| `resource` | Terraform でリソースを作るという宣言 |
| `"azurerm_resource_group"` | Azure 上の「リソースグループ」という種類のリソース |
| `"main"` | Terraform 内部で参照するための任意の名前（他ファイルでは `azurerm_resource_group.main.name` のように参照） |
| `name = "rg-${local.project}-${local.environment}"` | 作成されるリソースグループの名前。`"rg-"` は任意の接頭語で、「resource group」の略。`${local.project}` は "webapp"、`${local.environment}` は "dev" を意味し、最終的に `"rg-webapp-dev"` となる。 |
| `location = local.location` | リソースグループを作成するリージョン|
| `tags = local.common_tags` | Azure リソースにタグを付ける設定。`locals` で定義された共通タグを使用 |

##### Azure App Service 用のプラン作成

```hcl
resource "azurerm_service_plan" "main" {
  os_type  = "Linux"
  sku_name = local.config.app_service_sku
}
```

| 項目 | 説明 |
|------|------|
| `resource` | Terraform でリソースを作るという宣言 |
| `"azurerm_service_plan"` | Azure App Service の プラン（土台）を作成するためのリソースタイプ |
| `"main"` | Terraform 内部で参照するための任意の名前 |
| `os_type = "Linux"` | Web アプリを動かす OS を指定。ここでは Linux ベースの環境でアプリをホストする |
| `sku_name = local.config.app_service_sku` | 料金プランを指定。`locals` ブロック内で定義された値（例：`"F1"` = 無料プラン）を使用 |

##### Azure App Service（Linux + Node.js）でフロントエンドアプリを作成する定義

```hcl
resource "azurerm_linux_web_app" "frontend" {
  name                = "app-${local.project}-fe-${local.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id
  tags                = merge(local.common_tags, { Component = "Frontend" })

  site_config {
    always_on = false

    application_stack {
      node_version = "18-lts"
    }

    cors {
      allowed_origins     = ["*"]
      support_credentials = false
    }
  }

  app_settings = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "~18"
    "NODE_ENV"                     = "development"
    "API_BASE_URL"                 = "https://${var.backend_app_name}.azurewebsites.net"
  }
}
```
> この定義により、Node.js を使ったフロントエンド Web アプリを Linux 環境の Azure App Service 上に簡単にデプロイできる。

| 項目 | 説明 |
|------|------|
| `resource "azurerm_linux_web_app" "frontend"` | Azure の Linux 環境で動く Web アプリを作成するリソース宣言。`frontend` は Terraform 内での名前（任意） |
| `name = "app-${local.project}-fe-${local.environment}"` | 実際に Azure 上に作成される Web アプリ名 |
| `resource_group_name = azurerm_resource_group.main.name` | どのリソースグループにこの Web アプリを配置するかを指定 |
| `location = azurerm_service_plan.main.location` | リージョンの指定。App Service Plan と同じ場所にする。|
| `service_plan_id = azurerm_service_plan.main.id` | App Service Plan の ID を指定。この Web アプリが動作する土台 |
| `tags = merge(local.common_tags, { Component = "Frontend" })` | 共通タグに `"Component" = "Frontend"` を追加したタグ設定 |

##### `site_config { ... }` の中身

| 項目 | 説明 |
|------|------|
| `always_on = false` | 常時起動設定。無料プラン（F1）では使用不可のため false |
| `application_stack.node_version = "18-lts"` | Node.js のアプリケーションスタックとして LTSバージョン（v18）を使用 |
| `cors.allowed_origins = ["*"]` | すべてのドメインからのアクセスを許可（開発環境用） |
| `cors.support_credentials = false` | Cookie を含めた認証情報の送信を許可しない設定 |

##### `app_settings = { ... }` の中身

| 項目 | 説明 |
|------|------|
| `"WEBSITE_NODE_DEFAULT_VERSION" = "~18"` | Node.js のデフォルトバージョン指定 |
| `"NODE_ENV" = "development"` | Node.js アプリの環境変数。開発モードを指定 |
| `"API_BASE_URL" = "https://${var.backend_app_name}.azurewebsites.net"` | バックエンドAPIのベースURL。`terraform.tfvars` などで指定された `backend_app_name` を使用 |

##### Azure App Service（Linux + Node.js）でバックエンドアプリを作成する定義

```hcl
resource "azurerm_linux_web_app" "backend" {
  name                = "app-${local.project}-be-${local.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id
  tags                = merge(local.common_tags, { Component = "Backend" })

  site_config {
    always_on = false

    application_stack {
      node_version = "18-lts"
    }

    cors {
      allowed_origins = [
        "https://${azurerm_linux_web_app.frontend.default_hostname}",
        "http://localhost:3000",
        "http://localhost:5173"
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
```

##### `site_config.cors { ... }` の中身

| 項目 | 説明 |
|------|------|
| `cors { ... }` | CORS の設定を行うブロック |
| `https://${azurerm_linux_web_app.frontend.default_hostname}` | フロントエンドの Azure Web アプリの本番 URL を許可 |
| `http://localhost:3000` | React や Next.js の開発サーバー用ローカル URL（開発環境） |
| `http://localhost:5173` | Vite（Vue など）で使うローカル開発サーバー用 URL |
| `support_credentials = true` | 認証情報（Cookieやヘッダー）を含むリクエストを許可 |
>  `cors` はフロントエンドとバックエンドが別ドメイン・別ポートで動作する場合に必須の設定

##### `app_settings { ... }`（環境変数） の中身

| 項目 | 説明 |
|----------|------|
| `"DATABASE_URL"` | Azure SQL Server に接続するための情報。接続先サーバ名・データベース名・管理者ユーザー名・パスワードを組み合わせた接続文字列 |
| `"JWT_SECRET"` | JWT（JSON Web Token）認証に使う秘密鍵。トークンの暗号化／復号に使用される。`var.jwt_secret` は外部から渡される変数 |
> `app_settings` は Azure 上のアプリにとっての **環境変数のような役割** を果たし、データベースやセキュリティ情報の管理に利用される。

##### Azure SQL Database（MSSQL）を作成する定義

```hcl
# SQL Server の作成
# データベースをホストする「親サーバー」
resource "azurerm_mssql_server" "main" {
  name                         = "sql-${local.project}-${local.environment}"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = var.sql_admin_password
  tags                         = local.common_tags

  identity {
    type = "SystemAssigned"
  }
}

# SQL データベースの作成
# 実際にデータを入れる「本体」
resource "azurerm_mssql_database" "main" {
  name         = "${local.project}-db"
  server_id    = azurerm_mssql_server.main.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "LicenseIncluded"
  sku_name     = local.config.sql_sku
  tags         = local.common_tags
}

# 開発用ファイアウォール設定（Azure サービスからのアクセスを許可）
# 外部からの接続を許可する設定
resource "azurerm_mssql_firewall_rule" "azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# 開発用ファイアウォール設定（すべての IP からのアクセスを許可）
resource "azurerm_mssql_firewall_rule" "allow_all" {
  name             = "AllowAllIPs-DevOnly"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}
```

##### `resource "azurerm_mssql_server" "main" { ... }`の中身

| 項目 | 説明 |
|------------------|------|
| `resource "azurerm_mssql_server" "main"` | Azure SQL サーバーを作成するリソース |
| `identity { type = "SystemAssigned" }` | マネージド ID（システム割り当て）を有効化。App Service など他の Azure リソースと**セキュアに連携可能**になる。 |

##### `resource "azurerm_mssql_database" "main" { ... }`の中身

| 項目 | 説明 |
|------------------|------|
| `resource "azurerm_mssql_database" "main"` | 実際のデータベース本体を作成するリソース |
| `collation = "SQL_Latin1_General_CP1_CI_AS"` | 文字の並び順・照合順序の設定。日本語を含む一般的な用途に適している。 |
| `license_type = "LicenseIncluded"` | ライセンス込みで利用する設定。**別途ライセンスを所有していない場合に使用**する。 |

##### `resource "azurerm_mssql_firewall_rule" "azure_services" { ... }`の中身

| 項目 | 説明 |
|------------------|------|
| `resource "azurerm_mssql_firewall_rule" "azure_services"` | **Azure 内部のサービスのみ**に接続を許可するファイアウォールルール |
| `start_ip_address = "0.0.0.0"`<br>`end_ip_address = "0.0.0.0"` | **Azure 内部（App Serviceなど）からのアクセスのみ許可**する設定（外部インターネット不可） |

##### `resource "azurerm_mssql_firewall_rule" "allow_all" { ... }`の中身

| 項目 | 説明 |
|------------------|------|
| `resource "azurerm_mssql_firewall_rule" "allow_all"` | **全 IP アドレス**から接続を許可する設定 |
| `start_ip_address = "0.0.0.0"`<br>`end_ip_address = "255.255.255.255"` | インターネット上の **すべての IP から接続可能**になる設定。<br>⚠️ **開発時の一時的な用途に限定**し、**本番環境では絶対に使用しないこと** |

##### Azure Application Insights を作成する定義

```hcl
resource "azurerm_application_insights" "main" {
  name                = "appi-${local.project}-${local.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"
  tags                = local.common_tags
}
```

##### Azure ストレージアカウント & BLOB コンテナ（ファイル保存場所）を作成する定義

```hcl
# ストレージアカウントの作成
resource "azurerm_storage_account" "main" {
  name                     = "st${local.project}${local.environment}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.common_tags

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

# BLOB コンテナ の作成
resource "azurerm_storage_container" "uploads" {
  name                  = "uploads"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "blob"  # 公開読み取り（開発用途）
}
```

##### `resource "azurerm_storage_account" "main" { ... }`の中身

| 項目 | 説明 |
|------|------|
| `name = "st${local.project}${local.environment}"` | ストレージアカウント名。**小文字・英数字のみ、24文字以内**という Azure の命名制約あり |
| `account_tier = "Standard"` | ストレージのグレード。`Standard` は低価格帯（多くの開発環境で使用） |
| `account_replication_type = "LRS"` | データの冗長構成。`LRS` は「同一データセンター内での3重複製」 |
| `allow_nested_items_to_be_public = true` | ファイルやフォルダ（BLOB）を外部公開できるようにする設定。**開発環境では true が便利**（例：画像URLを共有） |

##### `blob_properties { cors_rule { ... } }`の中身

| 項目 | 説明 |
|------|------|
| `cors_rule` | CORS 設定ブロック。ブラウザアプリから直接アクセスさせる場合に必要 |
| `allowed_origins = ["*"]` | すべてのオリジン（ドメイン）からのアクセスを許可。**開発用に限定** |
| `allowed_methods = ["GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS"]` | 許可する HTTP メソッド一覧 |
| `max_age_in_seconds = 3600` | CORS の設定をブラウザがキャッシュする時間（秒） |

##### `resource "azurerm_storage_container" "uploads" { ... }`の中身

| 項目 | 説明 |
|------|------|
| `name = "uploads"` | コンテナ名。ストレージアカウント内の「フォルダのような場所」を定義 |
| `storage_account_name = azurerm_storage_account.main.name` | 紐づけるストレージアカウント名 |
| `container_access_type = "blob"` | 誰でも中のファイル（BLOB）を**URLで閲覧可能**な状態にする設定（ただしファイル一覧は見えない） |

---
