# AzureWebアプリ開発学習

## 用語集

---

### Azureとは？

- 読み：アジュール  
- Microsoft（マイクロソフト）が提供するクラウドサービス  
- サーバー、データベース、ネットワーク、AIなどの機能を「インターネット上で使えるようにしたサービス群」  
- 自分のPCにインストールしたり、物理サーバーを買ったりせずに使える

##### できること

| 項目         | 説明                         | 例えるなら…                    |
|--------------|------------------------------|-------------------------------|
| サーバー     | 自分のアプリを動かす場所     | アプリを置くパソコン（レンタル） |
| データベース | データを保存する場所         | ノートや記録帳のようなもの     |
| ネットワーク | サービス同士をつなぐ道       | 社内LAN・インターネット        |
| ログイン認証 | ユーザーを管理               | 社員証・パスワードチェック     |
| AIや分析     | 画像認識、チャットなど       | ChatGPTのような機能も使える    |

---

#### Virtual Networkとは？

- 読み：バーチャル ネットワーク  
- Azure上に作る「インターネット空間の中の安全な専用ネットワーク」  
- サービス同士を外から隔離してつなぐ道を作る

---

#### Application Gatewayとは？

- 読み：アプリケーション ゲートウェイ  
- 外部からのアクセスを最初に受け取る門番  
- 通信を振り分けたり、セキュリティチェックをしたりする

---

#### Azure App Serviceとは？

- 読み：アジュール アップ サービス  
- アプリを簡単に公開できるサービス  
- PythonやNode.jsなどのアプリをサーバーレスで簡単に動かせるサービス  
- サーバー構築不要でアプリをデプロイ（公開）できる

---

#### Private Linkとは？

- 読み：プライベート リンク  
- Azureサービス同士をインターネットを通さずに直接つなぐための仕組み  
- セキュリティが高くなる

---

#### Resource Groupとは？

- 読み：リソース グループ  
- Azure 上で作成した複数のリソースを「まとめて管理する入れ物」  
- 以下のようなものをバラバラに管理するのではなく、関連するもの同士を「ひとまとめ」に管理するために使う  
  - 仮想マシン（VM）  
  - データベース（MySQLなど）  
  - ストレージアカウント  
  - Web App（アプリケーションホスティング）  
  - 仮想ネットワーク（VNet）など  

---

#### App Service Planとは？

- 読み：アップ サービス プラン  
- Azure App Service を「どのスペック・料金プラン」で動かすかを決める設定  

##### App Service Plan で決定する内容

| 項目                | 説明                                           |
|---------------------|------------------------------------------------|
| CPU / メモリ        | どれくらいのスペックでアプリを動かすか         |
| 料金プラン          | サービスの内容と課金レベル（Free, Basicなど）  |
| スケール             | 同時アクセスに対応するための台数や自動拡張設定 |
| リージョン          | どの地域（例：Japan East）でサーバーを動かすか |

---

#### Azure SQL Databaseとは？

- 読み：アジュール エスキューエル データベース  
- 「Microsoftが運用管理してくれる、クラウド上のSQL Serverデータベース」

##### 特徴

| 項目                | 説明                                               |
|---------------------|----------------------------------------------------|
| リレーショナルDB     | 通常のSQL（SELECT, INSERTなど）で操作できる       |
| マネージドサービス   | サーバー管理・パッチ・バックアップをAzureが代行   |
| 高可用性             | 自動で冗長化されていて障害に強い                   |
| スケーラブル         | プランを変更して性能アップ・コストダウンが可能     |
| セキュリティ内蔵     | 暗号化、IP制限、プライベート接続など対応済み       |

---

#### Application Insightsとは？

- 読み：アプリケーション インサイト  
- アプリが「今どう動いているか？」をリアルタイムに見える化してくれる監視ツール

##### できること

| 機能                  | 説明                                             |
|-----------------------|--------------------------------------------------|
| アクセス数の記録      | どれくらいのユーザーが使っているか               |
| パフォーマンス測定    | 処理時間、遅延、エラーの発生状況など             |
| エラー検知            | 例外、失敗したAPIリクエストなどを収集            |
| トレースログの確認    | アプリ内のログ（console.logなど）を可視化        |
| リクエストの追跡      | 処理やサービスをまたぐ流れを見える化（分散トレース）|

---

#### Key Vaultとは？

- 読み：キー ボールト  
- Microsoft Azure が提供するパスワード・APIキー・証明書などの重要情報を安全に管理するためのサービス

##### できること

| 機能                | 説明                                                    |
|---------------------|---------------------------------------------------------|
| シークレットの保存   | DBパスワード、APIキー、接続文字列などを保管             |
| アクセス制御        | 誰がどの情報を読み書きできるか細かく設定可能            |
| 証明書の管理        | SSL/TLS証明書の保管と自動更新に対応                     |
| 暗号鍵の管理        | データ暗号化・復号化用の鍵を安全に管理                 |
| ロギング・監査対応  | いつ・誰が・どのキーにアクセスしたか記録される         |

---

#### Storage Accountとは？

- 読み：ストレージ アカウント  
- Azureでファイル、画像、動画、ログ、バックアップなどを安全に保存・管理するための「倉庫」  
- ストレージアカウントを作ると、その中に以下のような保存サービスが使えるようになる

| サービス名       | 用途                                                 |
|------------------|------------------------------------------------------|
| Blob Storage     | ファイルや画像・動画などの大容量データの保存        |
| File Storage     | 共有フォルダのように使える（Windows共有に似ている） |
| Queue Storage    | メッセージの送受信（非同期処理）に使う              |
| Table Storage    | シンプルなキーバリュー型データベース               |
| Disk Storage     | 仮想マシン用のディスク（OS・データ）                |

---

#### Network Security Group（NSG）とは？

- 読み：ネットワーク セキュリティ グループ  
- Azureの仮想マシンやサービスへの「通していい通信・ブロックすべき通信」を制御するルール集

---

#### Private Endpointとは？

- 読み：プライベート エンドポイント  
- Azureの重要なサービス（ストレージ、SQL Database、Key Vaultなど）に対して、インターネットを通さず、仮想ネットワーク経由で安全にアクセスするための仕組み  
- Azure内のサービスに「プライベートIPアドレス」でアクセスできるようにするネットワーク構成

---

#### 比較：AWSとAzureの違い

目的は同じ。強みや設計思想が少し違う

| 観点              | AWS                                | Azure                                  |
|-------------------|-------------------------------------|-----------------------------------------|
| 提供元            | Amazon（アマゾン）                 | Microsoft（マイクロソフト）             |
| 歴史              | 2006年スタート（早い）             | 2010年スタート（後発）                 |
| シェア            | 世界1位（最大手）                  | 世界2位（急成長）                      |
| 得意分野          | 開発者向け自由度・豊富なサービス数 | 企業向けの連携（特にMicrosoft製品）   |
| UIの印象          | エンジニア寄り、構成が細かい       | 分かりやすく直感的（初心者向け）      |
| 料金体系          | やや複雑だが細かく調整可能         | ややシンプルだが場合によっては高め     |
| デフォルト連携    | EC・ビッグデータ・MLとの相性良い    | Microsoft 365 / AD との相性が抜群     |
| 仮想ネットワーク名| VPC（Virtual Private Cloud）       | Virtual Network                        |
| サーバーレスアプリ| AWS Lambda                         | Azure Functions                         |
| Webアプリホスティング| Amplify / EC2 / ECS / App Runner | Azure App Service                      |
| 公式ドキュメント  | 技術者向けで網羅的                 | 丁寧で初心者向けハンズオンも多い       |

---

#### 比較：AzureとAWSの仮想ネットワーク

| 概念                | Azure                        | AWS                        | 説明                                                       |
|---------------------|-------------------------------|-----------------------------|------------------------------------------------------------|
| 仮想ネットワーク     | Virtual Network（VNet）      | VPC（Virtual Private Cloud）| クラウド上に作る「自分専用のネットワーク空間」              |
| サブネット           | Subnet                        | Subnet                      | VNet/VPCの中でネットワークを分割する単位                   |
| ルートテーブル       | User Defined Route（UDR）     | Route Table                 | 通信の経路を制御する設定                                   |
| インターネットゲートウェイ | インターネット接続（既定）     | Internet Gateway            | 外部インターネットと接続するための仕組み                   |
| NAT                | Azure NAT Gateway / インスタンス | NAT Gateway / インスタンス | プライベートサブネットからの外部通信を可能にする           |
| ピアリング           | VNet Peering                  | VPC Peering                 | 別の仮想ネットワークとの接続                               |

---

#### Azureの使い始め方

1. Azureアカウントを作る  
2. Azure Portal（管理画面） にログイン  
3. リソースグループを作成  
4. App Service を作って簡単なアプリを動かしてみる  
5. 仮想マシンやデータベースも徐々に触る  

---

### GitHub Copilotとは？

- 読み：ギットハブ コパイロット  
- AIがコード記載を手伝ってくれるツール  
- MicrosoftとOpenAIが共同開発した「AIペアプログラマー」  
- 関数の名前やコメントだけでも、コードの雛形や中身を自動生成してくれる  
- VS Codeなどでコードを書いていると、Copilotが自動的に続きを予測して提案してくれる  

---

### CURSORとは？

- 読み：カーソル  
- Copilotをさらに強化した「AIコーディング専用エディタ」  
- ChatGPTのようなチャット機能とコードエディタが連携していて、質問すると直接コードを直してくれたり、改善提案もしてくれる  
- Web検索も連携されており、ドキュメントを探す手間も省ける  

---

### Terraformとは？

- 読み：テラフォーム  
- IaCを実現する代表的なツール  
- HashiCorp社が開発したIaCツール  
- AWS、Azure、GCPなどのクラウドインフラを統一した書き方でコード化・構築できる  
- Terraformファイル（.tf）に書いた設定内容に応じて、サーバー、ネットワーク、DBなどを自動で用意してくれる  

---

##### Terraformの基本構成

| 構成     | 目的                                            | 例                                      |
|----------|-------------------------------------------------|-----------------------------------------|
| provider | どのクラウドを使うか（AWS, Azure, GCPなど）     | `provider "azurerm" {}`                |
| resource | どんなリソースを作るか（VM, DB, VNetなど）     | `resource "azurerm_resource_group"`     |
| variable | 変数を使って柔軟に設定する                     | `variable "location" { default = "japaneast" }` |
| output   | 実行後に値を表示する                           | `output "ip_address"`                   |
| locals   | 中間的な変数（ローカル値）                     | `locals { common_tags = { env = "dev" } }` |
| module   | 構成を再利用する部品化されたパーツ             | `module "network" { source = "./network" }` |

---

##### Terraformの実行コマンド（CLI）

| コマンド             | 説明                                   |
|----------------------|----------------------------------------|
| terraform init       | 初期化（プロバイダーのダウンロードなど） |
| terraform plan       | 何が作られるか確認                     |
| terraform apply      | 実際に作成                             |
| terraform destroy    | 削除                                   |
| terraform fmt        | コードを整形                           |

---

### LRS（ローカル冗長）とは？

- 同じリージョン（例：東日本）内の3台のサーバーにコピーする方式

---

### GRS（地理冗長）とは？

- 別のリージョン（遠く離れた地域）にも自動でコピーする方式

---

## 実装手順

### 1. Azureアカウント作成

個人メアドでアカウント作成

### 2. CURSORアカウント招待→参加

石田さんのアカウントにメンバーとして参加させていただいている。

### 3. CURSORで要件定義

* AIに要件定義やアプリ作成に必要なドキュメントを作成してもらう
* 作成された内容を確認

### 4. CURSOR上にフォルダ作成

以下のフォルダを CURSOR の中に作成：

| フォルダ               | 役割      | 中身                                      |
| ------------------ | ------- | --------------------------------------- |
| `be`               | バックエンド  | API、モデル、ルーティング                          |
| `fe`               | フロントエンド | VueやReactの画面コード                         |
| `infra`            | インフラ構成  | Terraform, Docker, CI/CD設定              |
| `docs`             | ドキュメント  | 設計資料、使い方説明                              |
| `environments/dev` | 開発環境設定  | `.env.dev`, `docker-compose.dev.yml` など |

### 5. 『04\_Terraform実践ガイド.md』に沿って環境構築

※docsフォルダ内のAIが作成してくれたアプリ開発ガイド

---

## 環境準備

### 必要なツールのインストール

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

## Azure認証設定

### Azureアカウントにログイン

```bash
az login
```

ブラウザが開くのでプライベートアカウントでログイン。

ターミナルに以下が表示されたらログイン完了：

```
Tenant: ◯◯◯◯◯
Subscription: ◯◯◯◯◯
```

### サブスクリプションの確認と切り替え

```bash
az account list --output table
```

| 列名             | 説明                           |
| -------------- | ---------------------------- |
| Name           | サブスクリプションの名前                 |
| CloudName      | 利用しているクラウド環境（通常は AzureCloud） |
| SubscriptionId | サブスクリプションの一意なID              |
| TenantId       | Azure ADのID                  |
| State          | 有効状態（Enabled なら利用可能）         |
| IsDefault      | True なら現在使用中のサブスクリプション       |

必要に応じてサブスクリプションを切り替える：

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

## Terraform基本理解

### 主要概念

#### Provider（プロバイダー）
- クラウドプロバイダー（Azure、AWS等）とのインターフェース  
- リソースの作成・管理方法を定義

#### Resource（リソース）
- 実際に作成するインフラコンポーネント  
- VM、データベース、ネットワーク等

#### State（状態）
- 現在のインフラ状態をTerraformが追跡  
- `terraform.tfstate` ファイルで管理

#### Plan（プラン）
- 実行前に変更内容を確認する機能  
- `terraform plan` コマンド

---

## 基本ワークフロー

| ステップ | 説明 |
|----------|------|
| A. コード記述 | `.tf` ファイルにインフラの構成（例：VM や VNet）を記述する |
| B. `terraform init` | 初期化：プラグイン・プロバイダー（例：azurerm）をダウンロード |
| C. `terraform plan` | 実行計画を確認：「何が作られるか」を表示（実際には作らない） |
| D. `terraform apply` | 実行計画に従ってリソースを本当に作成 |
| E. リソース作成 | Azure などに仮想マシンやリソースグループが作られる |
| F. `terraform destroy` | 作ったリソースを削除するコマンド（クリーンアップ） |

---

### フローまとめ

- コードを書く → 初期化 → 計画 → 適用 → 作成 →（必要に応じて）削除
- `.terraform/` フォルダ：初期化時に作成される設定用ディレクトリ
- `terraform.tfstate`：実行後の状態ファイル（重要）

---

### `terraform.tfstate` ファイルとは？

- Terraform が「**何を作ったか**」を記録するファイル
- 次回の `plan` や `apply` で**差分だけを適用**できる。
- **このファイルを削除すると、Terraform が記憶喪失状態に**なる。

---

### `terraform plan` の役割

- 実行前に「何が起きるか」を**安全に確認できるステップ**
- 実際には何も作成されないため、安心して変更内容を把握できる。

---

## Azureリソースの作成

### プロジェクトディレクトリへ移動

```bash
# 移動先ディレクトリ
cd infra/environments/dev
```
---

### 前提

Terraform は、**カレントディレクトリに存在する `.tf` ファイルをすべて読み取り**、定義された内容に基づいてリソースを作成する。

具体的には以下のファイルが含まれます：

| ファイル名 | 役割 |
|------------|------|
| `main.tf` | メインとなる設定（リソースの定義など） |
| `variables.tf` | 変数の定義（型や説明など） |
| `terraform.tfvars` | 変数に実際の値を割り当てるファイル |
| `outputs.tf` | 作成後に出力する項目（例：URLなど） |
| `provider.tf` | 使用するクラウド（Azureなど）と認証設定 |

>  すべての `.tf` ファイルがカレントディレクトリ内に揃っていれば、Terraform はそれらをまとめて処理する。

---

## `main.tf` の記載内容確認

`main.tf` は、Terraform で **「実際に何を作るか」** を定義するメインの構成ファイル


### 全体の構成イメージ

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
### 要素の意味

Terraform の構成ファイル（例：`main.tf`）で使用される主な要素の意味は以下の通り

| 項目 | 意味 |
|------|------|
| `terraform` | Terraform のバージョンや、使うプロバイダーを指定するセクション |
| `provider` | Azure など、どのクラウドを使用するかを指定（例：`azurerm`） |
| `locals` | 定数のように使い回す値を定義（例：location や tags など） |
| `resource` | 実際に作成したい Azure リソースを定義（例：Web アプリ、DB） |
| `site_config`, `app_settings` | Web アプリに対する詳細な設定（アプリ設定や構成） |
| `tags` | Azure 上での管理タグ（誰が作成したか、用途などを記録） |
---

### 基本構文

#### Terraform本体の設定

```hcl
terraform {
  required_version = ">= 1.0"  # Terraformのバージョン1.0以上で実行する
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"  # HashiCorp公式のAzureプロバイダーを使用
      version = "~> 3.0"             # バージョン3.0以上かつ4.0未満
    }
  }
}
```

| 項目 | 意味 |
|------|------|
| `required_version` | Terraform CLI のバージョン指定。例：`>= 1.0` は「バージョン 1.0 以上で実行してね」という意味 |
| `required_providers { ... }` | Terraform が使用するクラウドサービスのプロバイダー情報を指定するブロック |
| `azurerm = { ... }` | Azure のプロバイダーを使用することを指定 |
| `source = "hashicorp/azurerm"` | Terraform の公式プロバイダーリポジトリ（HashiCorp）から `azurerm` プロバイダーを取得する設定 |
| `version = "~> 3.0"` | 「バージョン 3.0 以上かつ 4.0 未満」を意味するバージョン指定のルール |
---

#### Azureに接続するためのプロバイダー設定

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
---

#### ローカル変数の定義

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
---

#### Azure でリソースグループを作成する定義

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
| `name = "rg-${local.project}-${local.environment}"` | 作成されるリソースグループの名前。`"rg-"` は任意の接頭語で、「resource group」の略。`${local.project}` は "webapp"、`${local.environment}` は "dev" を意味し、最終的に `"rg-webapp-dev"` となる |
| `location = local.location` | リソースグループを作成するリージョン（例：`Japan East`） |
| `tags = local.common_tags` | Azure リソースにタグを付ける設定。`locals` で定義された共通タグを使用 |
---

#### Azure App Service 用のプラン作成

```hcl
resource "azurerm_service_plan" "main" {
  os_type  = "Linux"
  sku_name = local.config.app_service_sku
}
```

| 項目 | 説明 |
|------|------|
| `resource` | Terraform に「サービスプランを作るよ」と宣言するキーワード |
| `"azurerm_service_plan"` | Azure App Service の「プラン（土台）」を作成するためのリソースタイプ |
| `"main"` | Terraform 内部でこのリソースを参照するための名前（任意） |
| `os_type = "Linux"` | Web アプリを動かす OS を指定。ここでは Linux ベースの環境でアプリをホストする |
| `sku_name = local.config.app_service_sku` | 料金プランを指定。`locals` ブロック内で定義された値（例：`"F1"` = 無料プラン）を使用 |
---

#### Azure App Service（Linux + Node.js）でフロントエンドアプリを作成する定義

```hcl
resource "azurerm_linux_web_app" "frontend" {
  name                = "app-${local.project}-fe-${local.environment}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id
  tags                = merge(local.common_tags, { Component = "Frontend" })

  site_config {
    always_on = false  # Free プランでは使用不可

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
| `name = "app-${local.project}-fe-${local.environment}"` | 実際に Azure 上に作成される Web アプリ名（例：`app-webapp-fe-dev`） |
| `resource_group_name = azurerm_resource_group.main.name` | どのリソースグループにこの Web アプリを配置するかを指定 |
| `location = azurerm_service_plan.main.location` | リージョンの指定。App Service Plan と同じ場所にする必要あり |
| `service_plan_id = azurerm_service_plan.main.id` | App Service Plan の ID を指定。この Web アプリが動作する「土台」 |
| `tags = merge(local.common_tags, { Component = "Frontend" })` | 共通タグに `"Component" = "Frontend"` を追加したタグ設定 |
---

#### `site_config { ... }` の中身

| 項目 | 説明 |
|------|------|
| `always_on = false` | 常時起動設定。無料プラン（F1）では使用不可のため false |
| `application_stack.node_version = "18-lts"` | Node.js のアプリケーションスタックとして LTS バージョン（v18）を使用 |
| `cors.allowed_origins = ["*"]` | すべてのドメインからのアクセスを許可（開発環境用） |
| `cors.support_credentials = false` | Cookie を含めた認証情報の送信を許可しない設定 |
---

#### `app_settings = { ... }` の中身
| 項目 | 説明 |
|------|------|
| `"WEBSITE_NODE_DEFAULT_VERSION" = "~18"` | Node.js のデフォルトバージョン指定 |
| `"NODE_ENV" = "development"` | Node.js アプリの環境変数。開発モードを指定 |
| `"API_BASE_URL" = "https://${var.backend_app_name}.azurewebsites.net"` | バックエンドAPIのベースURL。`terraform.tfvars` などで指定された `backend_app_name` を使用 |
---

#### Azure App Service（Linux + Node.js）でバックエンドアプリを作成する定義

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

#### `site_config.cors { ... }` の中身

| 項目 | 説明 |
|------|------|
| `cors { ... }` | CORS（クロスオリジンリソース共有）の設定を行うブロック |
| `https://${azurerm_linux_web_app.frontend.default_hostname}` | フロントエンドの Azure Web アプリの本番 URL を許可 |
| `http://localhost:3000` | React や Next.js の開発サーバー用ローカル URL（開発環境） |
| `http://localhost:5173` | Vite（Vue など）で使うローカル開発サーバー用 URL |
| `support_credentials = true` | 認証情報（Cookieやヘッダー）を含むリクエストを許可 |
---
>  `cors` はフロントエンドとバックエンドが別ドメイン・別ポートで動作する場合に必須の設定
---

#### `app_settings { ... }`（環境変数） の中身

| 項目 | 説明 |
|----------|------|
| `"DATABASE_URL"` | Azure SQL Server に接続するための情報。接続先サーバ名・データベース名・管理者ユーザー名・パスワードを組み合わせた接続文字列 |
| `"JWT_SECRET"` | JWT（JSON Web Token）認証に使う秘密鍵。トークンの暗号化／復号に使用される。`var.jwt_secret` は外部から渡される変数 |
---
> `app_settings` は Azure 上のアプリにとっての **環境変数のような役割** を果たし、データベースやセキュリティ情報の管理に利用される。
---

#### Azure SQL Database（MSSQL）を作成する定義

```hcl
# SQL Server（論理サーバー）の作成
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

#### `resource "azurerm_mssql_server" "main" { ... }`の中身

| 項目 | 説明 |
|------------------|------|
| `resource "azurerm_mssql_server" "main"` | Azure SQL サーバーを作成するリソース |
| `identity { type = "SystemAssigned" }` | マネージド ID（システム割り当て）を有効化。App Service など他の Azure リソースと**セキュアに連携可能**になる |
---

#### `resource "azurerm_mssql_database" "main" { ... }`の中身

| 項目 | 説明 |
|------------------|------|
| `resource "azurerm_mssql_database" "main"` | 実際のデータベース本体を作成するリソース |
| `collation = "SQL_Latin1_General_CP1_CI_AS"` | 文字の並び順・照合順序の設定。日本語を含む一般的な用途に適している |
| `license_type = "LicenseIncluded"` | ライセンス込みで利用する設定。**別途ライセンスを所有していない場合に使用**する |
---

#### `resource "azurerm_mssql_firewall_rule" "azure_services" { ... }`の中身

| 項目 | 説明 |
|------------------|------|
| `resource "azurerm_mssql_firewall_rule" "azure_services"` | **Azure 内部のサービスのみ**に接続を許可するファイアウォールルール |
| `start_ip_address = "0.0.0.0"`<br>`end_ip_address = "0.0.0.0"` | **Azure 内部（App Serviceなど）からのアクセスのみ許可**する設定（外部インターネット不可） |
---

#### `resource "azurerm_mssql_firewall_rule" "allow_all" { ... }`の中身

| 項目 | 説明 |
|------------------|------|
| `resource "azurerm_mssql_firewall_rule" "allow_all"` | **全 IP アドレス**から接続を許可する設定 |
| `start_ip_address = "0.0.0.0"`<br>`end_ip_address = "255.255.255.255"` | インターネット上の **すべての IP から接続可能**になる設定。<br>⚠️ **開発時の一時的な用途に限定**し、**本番環境では絶対に使用しないこと** |
---

#### Azure Application Insights を作成する定義

```hcl
resource "azurerm_application_insights" "main" {
  name                = "appi-${local.project}-${local.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"
  tags                = local.common_tags
}
```

#### Azure ストレージアカウント & BLOB コンテナ（ファイル保存場所）を作成する定義

```hcl
# ストレージアカウントの作成
resource "azurerm_storage_account" "main" {
  name                     = "st${local.project}${local.environment}"  # 小文字のみ・24文字以内
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"  # ローカル冗長（開発環境向け）
  tags                     = local.common_tags

  allow_nested_items_to_be_public = true  # 開発環境では公開設定を緩く

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

# BLOB コンテナ（ファイルアップロード用）の作成
resource "azurerm_storage_container" "uploads" {
  name                  = "uploads"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "blob"  # 公開読み取り（開発用途）
}
```

#### `resource "azurerm_storage_account" "main" { ... }`の中身

| 項目 | 説明 |
|------|------|
| `name = "st${local.project}${local.environment}"` | ストレージアカウント名。**小文字・英数字のみ、24文字以内**という Azure の命名制約あり |
| `account_tier = "Standard"` | ストレージのグレード。`Standard` は低価格帯（多くの開発環境で使用） |
| `account_replication_type = "LRS"` | データの冗長構成。`LRS` は「同一データセンター内での3重複製」 |
| `allow_nested_items_to_be_public = true` | ファイルやフォルダ（BLOB）を外部公開できるようにする設定。**開発環境では true が便利**（例：画像URLを共有） |
---

#### `blob_properties { cors_rule { ... } }`の中身

| 項目 | 説明 |
|------|------|
| `cors_rule` | CORS（クロスオリジンアクセス）設定ブロック。ブラウザアプリから直接アクセスさせる場合に必要 |
| `allowed_origins = ["*"]` | すべてのオリジン（ドメイン）からのアクセスを許可。**開発用に限定** |
| `allowed_methods = ["GET", "POST", "PUT", "DELETE", "HEAD", "OPTIONS"]` | 許可する HTTP メソッド一覧 |
| `max_age_in_seconds = 3600` | CORS の設定をブラウザがキャッシュする時間（秒） |
---

#### `resource "azurerm_storage_container" "uploads" { ... }`の中身

| 項目 | 説明 |
|------|------|
| `name = "uploads"` | コンテナ名。ストレージアカウント内の「フォルダのような場所」を定義 |
| `storage_account_name = azurerm_storage_account.main.name` | 紐づけるストレージアカウント名 |
| `container_access_type = "blob"` | 誰でも中のファイル（BLOB）を**URLで閲覧可能**な状態にする設定（ただしファイル一覧は見えない） |
---

## `outputs.tf` の記載内容確認

`outputs.tf` は、Terraformで作成したリソースの重要な情報を出力するためのファイル

Terraform 実行後に以下のような情報を **コマンドラインで表示する**ために使う

| 出力例 | 利用目的 |
|--------|----------|
| Web アプリの URL | アプリがどこに公開されたかすぐに確認できる |
| SQL データベースの名前 | 接続や設定確認に使える |
| ストレージアカウントの BLOB エンドポイント | フロントエンドや外部アプリとの連携に必要 |
---

### 基本構文

```hcl
output "名前" {
  description = "何を表示するのか？"
  value       = 実際に表示したい値
}
```

---

### ファイル記載内容一部解説

#### `main`（ラベル）について
```hcl
# Terraformではリソースを作るときに、以下のような形式で書く（別ファイル）。
# このときの "main" が ラベル
# この "main" を使うことで、Terraform内の他の場所からこのリソースを参照できる。

resource "azurerm_resource_group" "main" {
  name = "my-resource-group"
  location = "japanwest"
}
```

```hcl
# 以下の main は、リソースに付けたラベル
# azurerm_resource_group.main.name で「azurerm_resource_group のラベルが main であるものの name を取得するという意味になる。

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.main.name
}
```

#### `sql_server_fqdn`（SQL Serverに接続するためのアドレス）について

```hcl
# SQL Serverに接続するためのアドレス設定
# fqd = Fully Qualified Domain Name（完全修飾ドメイン名）

output "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL server"
  value = azurerm_mssql_server.main.fully_qualified_domain_name
}
```

#### `storage_account_primary_blob_endpoint`（BLOBアクセス用URL）について

```hcl
# BLOB（バイナリデータ）にアクセスするためのURL設定

output "storage_account_primary_blob_endpoint" {
  description = "The primary blob endpoint of the storage account"
  value = azurerm_storage_account.main.primary_blob_endpoint
}

```

## `variable.tf` の記載内容確認

Terraformにおいて変数を定義するための専用ファイル

### 変数定義をするメリット

| メリット | 内容 |
|----------|------|
| あとから値だけ変えて再利用できる | 環境（本番／開発）ごとに変数の値だけ変えれば、同じ構成ファイルを使い回せる。 |
| セキュリティ情報を直接 `main.tf` に書かずに済む | パスワードやAPIキーなどの機密情報を `main.tf` に直接書かず、`.tfvars` や外部ファイルで安全に管理できる。 |
| 複数人で作業する時に統一しやすい | 変数定義が1ヶ所にまとまっており、チーム開発時に設定のばらつきや混乱を防げる。 |
---

### 基本構文

```hcl
variable "変数名" {
  description = "この変数が何を意味するかの説明"
  type = 型（string, number, bool, listなど）
  default = デフォルト値（任意） 
  sensitive = true/false（秘密情報かどうか）
  validation {
    condition = 条件式（任意）
    error_message = 条件に合わないときに表示するエラー
  }
}
```

### `variables.tf` に定義した変数の使い方

Terraform では、変数を `variables.tf` で定義しておくことで、**`var.変数名`** の形式で同じファイル内や他のファイルから簡単に呼び出して利用できる。

|  使用例      | |
|------------|--------|
| 変数定義   | `variables.tf` ファイルに記述 |
| 変数呼び出し | 他の `.tf` ファイル内で `var.変数名` を使って参照 |
---

####  変数定義の例（`variables.tf`）

```hcl
variable "backend_app_name" {
  description = "Backend app name for API URL construction"
  type        = string
  default     = "app-webapp-be-dev"
}
```

####  変数呼び出しの例（`別ファイル`）
```hcl
resource "azurerm_linux_web_app" "backend" {
  name = var.backend_app_name
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  service_plan_id = azurerm_service_plan.main.id
}
```

### `terraform.tfvars.example` をコピーして `terraform.tfvars` を作成

```bash
cp terraform.tfvars.example terraform.tfvars
```

## `terraform.tfvars` の記載内容確認

Terraformの変数（variables.tf で定義したもの）に、実際の値を設定するファイル

### `terraform.tfvars` の記述例（開発環境用）

```hcl
# ==============================================================================
# 開発環境用 変数値
# ==============================================================================

# SQL Server 管理者パスワード
sql_admin_password = "◯◯◯◯◯"

# JWT署名用シークレットキー
jwt_secret = "◯◯◯◯◯"

# バックエンドアプリ名（※ variables.tf にデフォルトが定義されているため省略可能）
# backend_app_name = "webapp-practice-be-dev"
```

## `.gitignore` ファイルで `terraform.tfvars` を隠す

### 理由

terraform.tfvars に記載しているパスワードやトークンなどの機密情報を隠すため

### プロジェクトルートに .gitignore ファイルがあるか確認
```bash
ls -a
```
### 存在しなければ、プロジェクトのルート（＝AzureWebApp/の直下） 

```bash
touch .gitignore
```

### .gitignore に以下のとおり記載
```hcl
# terraform の秘密ファイル
terraform.tfvars

# Terraformのプロバイダープラグイン実行バイナリ(容量大)
.terraform/
```







---
※記載途中
