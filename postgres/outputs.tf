output "namespace" {
  value = kubernetes_namespace.postgres.metadata[0].name
}

output "service_name" {
  value = kubernetes_service.postgres.metadata[0].name
}

output "connection_string" {
  value     = "postgresql://admin:rootpassword@${kubernetes_service.postgres.metadata[0].name}.${kubernetes_namespace.postgres.metadata[0].name}.svc.cluster.local:5432/appdb"
  sensitive = true
}
