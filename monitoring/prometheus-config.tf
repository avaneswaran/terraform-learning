resource "kubernetes_config_map" "prometheus" {
  metadata {
    name      = "prometheus-config"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }

  data = {
    "prometheus.yml" = <<-EOT
      global:
        scrape_interval: 15s

      scrape_configs:
        - job_name: 'prometheus'
          static_configs:
            - targets: ['localhost:9090']

        - job_name: 'node-exporter'
          static_configs:
            - targets: ['192.168.56.102:9100', '192.168.56.103:9100']

        - job_name: 'kube-state-metrics'
          static_configs:
            - targets: ['kube-state-metrics.monitoring.svc.cluster.local:8080']
    EOT
  }
}
