terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.23"
    }
  }
}

provider "vault" {
  address = "http://127.0.0.1:8200"
  token   = "root"
}

# Enable KV secrets engine
resource "vault_mount" "kv" {
  path        = "kv"
  type        = "kv"
  options     = { version = "2" }
  description = "KV Version 2 secrets engine"
}

# Create a secret
resource "vault_kv_secret_v2" "db_creds" {
  mount = vault_mount.kv.path
  name  = "database/prod"

  data_json = jsonencode({
    username = "dbadmin"
    password = "supersecret123"
  })
}

# Create a policy
resource "vault_policy" "app_policy" {
  name = "app-policy"

  policy = <<EOT
path "kv/data/database/*" {
  capabilities = ["read", "list"]
}
EOT
}

# Enable AppRole auth
resource "vault_auth_backend" "approle" {
  type = "approle"
}

# Create an AppRole
resource "vault_approle_auth_backend_role" "app" {
  backend        = vault_auth_backend.approle.path
  role_name      = "my-app"
  token_policies = [vault_policy.app_policy.name]
  token_ttl      = 3600
  token_max_ttl  = 14400
}

# Imported policy
resource "vault_policy" "admin" {
  name   = "admin-policy"
  policy = <<EOT
path "*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}
EOT
}
