output "namespace" {
  value = kubernetes_namespace.monitoring.metadata[0].name
}

output "prometheus_service" {
  value = kubernetes_service.prometheus.metadata[0].name
}

output "grafana_service" {
  value = kubernetes_service.grafana.metadata[0].name
}
