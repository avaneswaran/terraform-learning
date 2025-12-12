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

# Enable database secrets engine
resource "vault_mount" "database" {
  path        = "database"
  type        = "database"
  description = "Database secrets engine"
}

# Configure PostgreSQL connection
resource "vault_database_secret_backend_connection" "postgres" {
  backend       = vault_mount.database.path
  name          = "postgres"
  allowed_roles = ["app-role"]

  postgresql {
    connection_url = "postgresql://admin:rootpassword@10.200.1.25:5432/appdb?sslmode=disable"
  }
}

# Create a role that generates dynamic credentials
resource "vault_database_secret_backend_role" "app_role" {
  backend             = vault_mount.database.path
  name                = "app-role"
  db_name             = vault_database_secret_backend_connection.postgres.name
  creation_statements = ["CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";"]
  default_ttl         = 3600
  max_ttl             = 86400
}
