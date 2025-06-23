# 開発手順
## 1. Azureアカウント作成

## 2. CURSORアカウント招待受けるか作成

## 3. CURSOR上にフォルダ作成

以下のフォルダを CURSOR の中に作成：
| フォルダ               | 役割      | 中身                                      |
| ------------------ | ------- | --------------------------------------- |
| `be`               | バックエンド  | API、モデル、ルーティング                          |
| `fe`               | フロントエンド | VueやReactの画面コード                         |
| `infra`            | インフラ構成  | Terraform, Docker, CI/CD設定              |
| `docs`             | ドキュメント  | 設計資料、使い方説明                              |
| `environments/dev` | 開発環境設定  | `.env.dev`, `docker-compose.dev.yml` など |

## 4. CURSORで要件定義

- 要件定義をし、AIがアプリ作成に必要なドキュメントとファイルを作成し、上記フォルダに格納
- 作成された内容を確認

## 5. 『04\_Terraform実践ガイド.md』に沿って環境構築

※ 上記「4. CURSORで要件定義」で作成されたdocsフォルダ内ファイル

### ①必要なツールのインストール

#### Terraformのインストール（Homebrew使用）

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
terraform version
```

出力例：

```
Terraform v1.12.2
on darwin_arm64
```

#### Azure CLIのインストール

```bash
brew install azure-cli
az version
```

出力例：

```json
{
  "azure-cli": "◯.◯.◯",
  "azure-cli-core": "◯.◯.◯",
  "azure-cli-telemetry": "◯.◯.◯",
  "extensions": {}
}
```

---

### ②Azure認証設定

#### Azureアカウントにログイン

```bash
az login
```

- ブラウザが開くため、プライベートアカウントでログイン

- ターミナルに以下が表示されたらログイン完了

```
Tenant: ◯◯◯◯◯
Subscription: ◯◯◯◯◯
```

#### サブスクリプションの確認と切り替え

##### サブスクリプションの確認

```bash
az account list --output table
```

|  表示された一覧の列名             | 説明                           |
| -------------- | ---------------------------- |
| Name           | サブスクリプションの名前                 |
| CloudName      | 利用しているクラウド環境（通常は AzureCloud） |
| SubscriptionId | サブスクリプションの一意なID              |
| TenantId       | Azure ADのID                  |
| State          | 有効状態（Enabled なら利用可能）         |
| IsDefault      | True なら現在使用中のサブスクリプション       |

##### 必要に応じてサブスクリプションを切り替え

```bash
az account set --subscription "<subscription-name-or-id>"
```

現在ログイン中の情報を確認：

```bash
az account show
```

出力例：

```json
{
  "environmentName": "◯◯◯◯◯",
  "homeTenantId": "◯◯◯◯◯",
  "id": "◯◯◯◯◯",
  "isDefault": true,
  "managedByTenants": [],
  "name": "◯◯◯◯◯",
  "state": "◯◯◯◯◯",
  "tenantDefaultDomain": "◯◯◯◯◯",
  "tenantDisplayName": "◯◯◯◯◯",
  "tenantId": "◯◯◯◯◯",
  "user": {
    "name": "◯◯◯◯◯",
    "type": "◯◯◯◯◯"
  }
}
```
---

### ③Terraform基本理解

#### 主要概念

- Provider（プロバイダー）
  - クラウドプロバイダー（Azure、AWS等）とのインターフェース  
  - リソースの作成・管理方法を定義

- Resource（リソース）
  - 実際に作成するインフラコンポーネント  
  - VM、データベース、ネットワーク等

- State（状態）
  - 現在のインフラ状態をTerraformが追跡  
  - `terraform.tfstate` ファイルで管理

- Plan（プラン）
  - 実行前に変更内容を確認する機能  
  - `terraform plan` コマンド

---

### ④基本ワークフロー

| ステップ | 説明 |
|----------|------|
| 1. コード記述 | `.tf` ファイルにインフラの構成（例：VM や VNet）を記述する |
| 2. `terraform init` | 初期化：プラグイン・プロバイダー（例：azurerm）をダウンロード |
| 3. `terraform plan` | 実行計画を確認：「何が作られるか」を表示（実際には作らない） |
| 4. `terraform apply` | 実行計画に従ってリソースを本当に作成 |
| 5. リソース作成 | Azure などに仮想マシンやリソースグループが作られる |
| 6. `terraform destroy` | 作ったリソースを削除するコマンド（クリーンアップ） |

---

### ⑤Azureリソースの作成

#### 前提

Terraform は、**カレントディレクトリに存在する `.tf` ファイルをすべて読み取り**、定義された内容に基づいてリソースを作成する。

| ファイル名 | 役割 |
|------------|------|
| `main.tf` | メインとなる設定（リソースの定義など） |
| `variables.tf` | 変数の定義（型や説明など） |
| `terraform.tfvars` | 変数に実際の値を割り当てるファイル |
| `outputs.tf` | 作成後に出力する項目（例：URLなど） |
| `provider.tf` | 使用するクラウド（Azureなど）と認証設定 |

---

#### プロジェクトディレクトリへ移動

```bash
# 移動先ディレクトリ
cd infra/environments/dev
```

---

## 以下の項目（⑤-1〜⑤-4）は記述量が多いため、別ファイルに記載する。

### 「⑤-1`main.tf` の記載内容の確認」　→ DEVELOPMENT_5-1.md
### 「⑤-2`outputs.tf` の記載内容の確認」　→ DEVELOPMENT_5-2.md
### 「⑤-3`variable.tf` の記載内容の確認」　→ DEVELOPMENT_5-3.md
### 「⑤-4`terraform.tfvars.example` をコピーして `terraform.tfvars` を作成」→ DEVELOPMENT_5-4.md
### 「⑤-4`terraform.tfvars` の記載内容の確認」 → DEVELOOPMENT_5-4.md
### 「⑤-4`.gitignore` ファイルで `terraform.tfvars` を隠す」 → DEVELOPMENT_5-4.md

---

### ⑥Terraform実行

#### 初期化

```bash
terraform init
```

- `.terraform/` ディレクトリが作成される。
- Azure Provider がダウンロードされる。
- バックエンド設定が初期化される。

#### 現在のプラン確認

```bash
terraform plan
```

- 実行されるとAzureに作成予定のリソースが確認できる。
- 作成される Azure のリソースや、その設定内容を確認できる。
- 確認ポイント：作成されるリソース数、各リソースの設定内容、料金の概算

#### terraform plan で確認した「これから起こる変更」を、実際にクラウド上で反映（適用）

```bash
terraform apply
```

上記を実行すると、アクションを実行するかを確認されるため、「yes」を入力して実行を承認

#### Azureリソースの状況

##### 作成できたリソース
- azurerm_resource_group.main（リソースグループ）
- azurerm_application_insights.main（App Insights）
- azurerm_mssql_server.main（SQLサーバー）
- azurerm_mssql_firewall_rule.*（SQLのファイアウォールルール）
- azurerm_mssql_database.main（SQLデータベース）

##### 作成できなかったリソース（1/2）

- `App Service Plan`

###### エラー内容

- `401 Unauthorized`
  - リクエストされたリソースにアクセスするための認証情報が不足していることを示す。

- `Quota不足`
  - Quota：Azureなどのクラウドサービスで使えるリソースの上限数（制限）のこと
  - システムのリソースが、現在利用可能な量を超えている状態を指す。

###### エラーメッセージ箇所

```hcl
Operation cannot be completed without additional quota.
Current Limit (Free VMs): 0
Current Usage: 0
Amount required for this deployment (Free VMs): 0
```

###### 原因

- Azure サブスクリプションには「Free VM」枠のリソースが作成できない制限（＝割り当て上限が0）がある。
  App Service Plan は仮想マシンリソースを消費するため、この制限により作成不可となっている。
- 401 Unauthorized については、権限不足やアクセス制限が影響している可能性がある。

###### 対処方法

- Azureポータルで「クォータの増加申請」をする（サポート→クォータ→App Service Plan関連）または、App Service Plan の SKU を Free 以外（B1など）に変更して試す。
- ロールが「所有者（Owner）」であるか確認

###### エラー解消手順

- Azureポータルで権限確認
  - サブスクリプションレベルのロール確認
    - Azureポータルにログイン
    - 左上の「ハンバーガーメニュー」からサブスクリプションを検索してクリック
    - 使用しているサブスクリプションをクリック
    - 左メニューで「アクセス制御 (IAM)」を選択
    - 「ロールの割り当て」タブをクリック
    - 一覧から自分の名前（またはメールアドレス）を探す。自分のアカウントに「所有者 (Owner)」が割り当てられているか確認
  - リソースグループ単位で確認する場合
    - 左側メニューから「リソース グループ」を選択
    - 該当のリソースグループをクリック
    - 左メニューから「アクセス制御 (IAM)」を選択
    - 「ロールの割り当て」タブで、自分に Owner ロールがあるか確認

- クォータの増加申請（サポートに申請連絡後、数時間〜１日かかる）
  - 以下URLを参考に申請
    - 途中で詰まったら従課金制（Basic）にアップデートして、数分待ってから再度同じ手順で進める。
    - https://learn.microsoft.com/ja-jp/azure/extended-zones/request-quota-increase
    - なぜこのような対応が必要なのか？
      - Azureは新規ユーザーや無料枠のサブスクリプションに対して、以下を初期状態で制限している（不正利用・料金爆発を防ぐため）。
        | リソースの種類                  | 初期クォータ         |
        |-------------------------------|----------------------|
        | App Service Plan（B1/S1など） | 0台（作成不可）      |
        | 仮想マシン（Standard VM）     | 0〜数台              |
        | Premium Storage など          | 利用制限あり          |

- 修正
   - main.tf で App Service PlanのSKUを F1（Free）→ B1（Basic）に変更
   - 現在、 Azure 側で Free (F1) プランのクォータが 0 のため、デプロイできない。そのため、比較的安価な B1 プラン（有料）に変更
   ```hcl
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
        app_service_sku = "B1"  # ← F1 から B1 に変更
        sql_sku        = "Basic"
        backup_enabled = false
      }
    }
   ```

##### 作成できなかったリソース（2/2）

- `Storage Account`

###### エラー内容

- `409 Conflict`
  - クライアントからのリクエストがサーバー上の現在の状態と競合しているため、処理できないことを示す。このエラーは、主にリソースの同時更新や競合が発生した場合に返される。

###### エラーメッセージ箇所

```hcl
StorageAccountAlreadyTaken: The storage account named stwebappdev is already taken.
```

###### 原因

- ストレージアカウントはAzure全体で一意である必要があるが、すでに他ユーザーか別サブスクリプションで同一の名前が使われている。

###### 対処方法

- ストレージアカウント名をユニークなものに変更する。

###### エラー解消手順

- 修正
  - main.tf で Storage Account名を変更（以下の部分追加）

  ```hcl
    # ==============================================================================
    # 開発環境用 Terraform 設定
    # ==============================================================================

    terraform {
      required_providers {
        random = {                      # ← randomブロック追加
          source  = "hashicorp/random"
          version = "~> 3.0"
        }
        azurerm = {
          source  = "hashicorp/azurerm"
          version = "~> 3.0"
        }
      }
      required_version = ">= 1.0"
    }


    provider "azurerm" {
      features {
        key_vault {
          purge_soft_delete_on_destroy    = true
          recover_soft_deleted_key_vaults = true
        }
      }
    }
  ```

  ```hcl
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
        app_service_sku = "B1"  # ← F1 から B1 に変更
        sql_sku        = "Basic"
        backup_enabled = false
      }
    }

    resource "random_string" "storage_suffix" {  # ← resourceブロック追加
      length  = 4
      pper   = false
      special = false
    }
  ```

  ```hcl
    # ==============================================================================
    # Storage Account
    # ==============================================================================

    resource "azurerm_storage_account" "main" {
      name                     = "st${local.project}${local.environment}${random_string.storage_suffix.result}"  # ${random_string.storage_suffix.result}"追加
      resource_group_name      = azurerm_resource_group.main.name
      location                 = azurerm_resource_group.main.location
      account_tier             = "Standard"
      account_replication_type = "LRS"  # 開発環境はローカル冗長で十分
      tags                    = local.common_tags
    
    以下省略
  ```

  - 上記「エラー解消手順」後以下を実行
    - terraform init
    - terraform plan で差分確認
    - terraform apply で再デプロイ

---

※記載途中
