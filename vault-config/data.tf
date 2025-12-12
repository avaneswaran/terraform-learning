# Read the AppRole role ID
data "vault_approle_auth_backend_role_id" "app" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.app.role_name
}

# Generate a secret ID for the AppRole
resource "vault_approle_auth_backend_role_secret_id" "app" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.app.role_name
}
