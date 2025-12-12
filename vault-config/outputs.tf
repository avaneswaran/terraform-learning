output "approle_role_name" {
  value = vault_approle_auth_backend_role.app.role_name
}

output "secret_path" {
  value = "${vault_mount.kv.path}/database/prod"
}

output "approle_role_id" {
  value = data.vault_approle_auth_backend_role_id.app.role_id
}

output "approle_secret_id" {
  value     = vault_approle_auth_backend_role_secret_id.app.secret_id
  sensitive = true
}
