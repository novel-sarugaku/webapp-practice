### ⑤-3`variable.tf` の記載内容の確認

Terraformにおいて変数を定義するための専用ファイル

#### 変数定義をするメリット

| メリット | 内容 |
|----------|------|
| あとから値だけ変えて再利用できる | 環境（本番／開発）ごとに変数の値だけ変えれば、同じ構成ファイルを使い回せる。 |
| セキュリティ情報を直接 `main.tf` に書かずに済む | パスワードやAPIキーなどの機密情報を `main.tf` に直接書かず、`.tfvars` や外部ファイルで安全に管理できる。 |
| 複数人で作業する時に統一しやすい | 変数定義が1ヶ所にまとまっており、チーム開発時に設定のばらつきや混乱を防げる。 |
---

#### 基本構文

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

#### `variables.tf` に定義した変数の使い方

Terraform では、変数を `variables.tf` で定義しておくことで、**`var.変数名`** の形式で同じファイル内や他のファイルから簡単に呼び出して利用できる。

|  使用例      | |
|------------|--------|
| 変数定義   | `variables.tf` ファイルに記述 |
| 変数呼び出し | 他の `.tf` ファイル内で `var.変数名` を使って参照 |
---

#####  変数定義の例（`variables.tf`）

```hcl
variable "backend_app_name" {
  description = "Backend app name for API URL construction"
  type        = string
  default     = "app-webapp-be-dev"
}
```

#####  変数呼び出しの例（`別ファイル`）
```hcl
resource "azurerm_linux_web_app" "backend" {
  name = var.backend_app_name
  resource_group_name = azurerm_resource_group.main.name
  location = azurerm_resource_group.main.location
  service_plan_id = azurerm_service_plan.main.id
}
```

---
