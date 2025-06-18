# Infrastructure as Code (Terraform)

このディレクトリにはTerraformを使用したAzure環境の構築用コードが含まれています。

## 📁 ディレクトリ構造

```
infra/
├── README.md                    # このファイル
├── environments/                # 環境別設定
│   └── dev/                    # 開発環境
│       ├── main.tf             # メインのリソース定義
│       ├── variables.tf        # 変数定義
│       ├── outputs.tf          # 出力値定義
│       └── terraform.tfvars.example  # 変数値サンプル
└── modules/                    # 再利用可能なモジュール（今後作成予定）
```

## 🚀 クイックスタート

### 1. 前提条件

- [Terraform](https://www.terraform.io/downloads.html) (>= 1.0) がインストールされていること
- [Azure CLI](https://docs.microsoft.com/cli/azure/install-azure-cli) がインストールされていること
- Azure アカウントにログインしていること

```bash
# Azure CLI でログイン
az login

# 利用可能なサブスクリプションを確認
az account list --output table

# 使用するサブスクリプションを設定（必要に応じて）
az account set --subscription "Your-Subscription-ID"
```

### 2. 環境変数の設定

```bash
cd infra/environments/dev

# サンプルファイルをコピー
cp terraform.tfvars.example terraform.tfvars

# 実際の値を設定（エディタで編集）
vim terraform.tfvars
```

### 3. Terraformの実行

```bash
# 初期化
terraform init

# プランの確認（何が作成されるかを確認）
terraform plan

# 実際にリソースを作成
terraform apply
```

## 📋 作成されるAzureリソース

### 開発環境 (dev)

| リソース種別 | リソース名 | SKU/プラン | 月額料金概算 |
|-------------|-----------|----------|-------------|
| Resource Group | rg-webapp-dev | - | 無料 |
| App Service Plan | asp-webapp-dev | F1 (Free) | 無料 |
| Web App (Frontend) | app-webapp-fe-dev | F1 | 無料 |
| Web App (Backend) | app-webapp-be-dev | F1 | 無料 |
| SQL Server | sql-webapp-dev | - | 無料 |
| SQL Database | webapp-db | Basic | ¥500/月 |
| Application Insights | appi-webapp-dev | - | 5GB/月まで無料 |
| Storage Account | stwebappdev | Standard LRS | ¥100-300/月 |

**開発環境合計**: 約 ¥600-800/月

## 🔒 セキュリティ設定

### 開発環境の特徴

- **Free プラン使用**: コストを最小限に抑制
- **緩いセキュリティ**: 開発・学習目的のため制限を緩和
- **全IP許可**: SQL Serverへの接続を簡単にするため（本番環境では絶対に使用しない）

⚠️ **警告**: 開発環境の設定は本番環境では使用しないでください

## 🎯 出力値

Terraform apply後に以下の情報が出力されます:

```bash
# Web App の URL を確認
terraform output frontend_url
terraform output backend_url

# データベース接続情報を確認
terraform output sql_server_fqdn
terraform output sql_database_name
```

## 🧹 リソースの削除

**注意**: この操作は元に戻せません！

```bash
# すべてのリソースを削除
terraform destroy
```

## 🔧 トラブルシューティング

### よくある問題

1. **リソース名の重複エラー**
   ```
   Error: A resource with the ID already exists
   ```
   - 解決策: `main.tf` でリソース名にランダム文字列を追加

2. **SQL Server パスワード要件エラー**
   ```
   Error: Password does not meet requirements
   ```
   - 解決策: 8文字以上で英大文字・小文字・数字・記号を含むパスワードを設定

3. **認証エラー**
   ```
   Error: Unable to configure the Azure Provider
   ```
   - 解決策: `az login` でAzureにログインしているか確認

### ログ確認

```bash
# Terraform のデバッグログを有効にする
export TF_LOG=DEBUG
terraform apply
```

## 📚 次のステップ

1. **本番環境の設定**: `infra/environments/prod/` の作成
2. **モジュール化**: 共通リソースをモジュールとして切り出し
3. **CI/CD統合**: GitHub Actions または Azure DevOps との連携
4. **状態管理**: Remote Backend (Azure Storage) の設定

## 🔗 参考資料

- [Terraform Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure App Service Documentation](https://docs.microsoft.com/azure/app-service/)
- [Azure SQL Database Documentation](https://docs.microsoft.com/azure/sql-database/) 