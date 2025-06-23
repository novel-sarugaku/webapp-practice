### ⑤-2`outputs.tf` の記載内容の確認

`outputs.tf` は、Terraformで作成したリソースの重要な情報を出力するためのファイル

Terraform 実行後に以下のような情報を **コマンドラインで表示する**ために使う。

| 出力例 | 利用目的 |
|--------|----------|
| Web アプリの URL | アプリがどこに公開されたかすぐに確認できる。 |
| SQL データベースの名前 | 接続や設定確認に使える。 |
| ストレージアカウントの BLOB エンドポイント | フロントエンドや外部アプリとの連携に必要 |

#### 基本構文

```hcl
output "名前" {
  description = "何を表示するのか？"
  value       = 実際に表示したい値
}
```

#### 記載内容一部解説

##### `main`（ラベル）について
```hcl
# Terraformではリソースを作るときに、別ファイルに以下のような形式で記載する。
# このときの "main" が ラベル。この "main" を使うことで、Terraform内の他の場所からこのリソースを参照できる。

resource "azurerm_resource_group" "main" {
  name = "my-resource-group"
  location = "japanwest"
}
```

```hcl
# azurerm_resource_group.main.name →　azurerm_resource_group のラベルが main であるものの name を取得する

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.main.name
}
```

##### `sql_server_fqdn`（SQL Serverに接続するためのアドレス）について

```hcl
# SQL Serverに接続するためのアドレス設定
# fqdn → 完全修飾ドメイン名

output "sql_server_fqdn" {
  description = "The fully qualified domain name of the SQL server"
  value = azurerm_mssql_server.main.fully_qualified_domain_name
}
```

##### `storage_account_primary_blob_endpoint`（BLOB にアクセスするためのURL）について

```hcl
# BLOB ストレージ → 画像、PDF、動画、CSVなどのファイルを保存する場所
# ストレージアカウントのBLOBサービスにアクセスするためのURL（エンドポイント）
# フロントエンドやAPIから、BLOBにあるファイル（画像・データ）を取得したりアップロードする際に使う

output "storage_account_primary_blob_endpoint" {
  description = "The primary blob endpoint of the storage account"
  value = azurerm_storage_account.main.primary_blob_endpoint
}

```
---

