output "vault_namespace" {
  value = kubernetes_namespace.vault.metadata[0].name
}

output "vault_service" {
  value = kubernetes_service.vault.metadata[0].name
}

output "vault_node_port" {
  value = kubernetes_service.vault.spec[0].port[0].node_port
}
