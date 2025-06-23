### ⑤-4`terraform.tfvars.example` をコピーして `terraform.tfvars` を作成

```bash
cp terraform.tfvars.example terraform.tfvars
```

---

### ⑤-4`terraform.tfvars` の記載内容の確認

Terraformの変数（variables.tf で定義したもの）に、実際の値を設定するファイル

#### `terraform.tfvars` の記述例（開発環境用）

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

---

### ⑤-4`.gitignore` ファイルで `terraform.tfvars` を隠す

#### 理由

terraform.tfvars に記載しているパスワードやトークンなどの機密情報を隠すため

#### プロジェクトルートに .gitignore ファイルがあるか確認

```bash
ls -a
```

#### 存在しなければ、プロジェクトのルート（＝AzureWebApp/の直下） に .gitignore 作成

```bash
touch .gitignore
```

#### .gitignore に以下のとおり記載

```hcl
# terraform の秘密ファイル
terraform.tfvars

# Terraformのプロバイダープラグイン実行バイナリ(容量が大きいため)
.terraform/
```

---
