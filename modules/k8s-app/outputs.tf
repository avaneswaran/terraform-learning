output "service_name" {
  value = kubernetes_service.app.metadata[0].name
}

output "cluster_ip" {
  value = kubernetes_service.app.spec[0].cluster_ip
}
