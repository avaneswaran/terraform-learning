output "namespace" {
  value = kubernetes_namespace.consul.metadata[0].name
}

output "service_name" {
  value = kubernetes_service.consul.metadata[0].name
}

output "http_node_port" {
  value = kubernetes_service.consul.spec[0].port[0].node_port
}
