resource "kubernetes_config_map" "prometheus_config" {
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
            - targets:
              - '192.168.56.102:9100'
              - '192.168.56.103:9100'
              labels:
                cluster: 'k8s-lab'

        - job_name: 'vault'
          metrics_path: '/v1/sys/metrics'
          params:
            format: ['prometheus']
          bearer_token: 'root'
          static_configs:
            - targets: ['10.200.1.31:8200']
              labels:
                service: 'vault'
    EOT
  }
}
