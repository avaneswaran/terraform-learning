terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.24"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }
}

resource "kubernetes_deployment" "consul" {
  metadata {
    name      = "consul"
    namespace = kubernetes_namespace.consul.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "consul"
      }
    }

    template {
      metadata {
        labels = {
          app = "consul"
        }
      }

      spec {
        container {
          name  = "consul"
          image = "hashicorp/consul:1.17"

          args = ["agent", "-dev", "-client=0.0.0.0"]

          port {
            name           = "http"
            container_port = 8500
          }

          port {
            name           = "dns"
            container_port = 8600
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "consul" {
  metadata {
    name      = "consul"
    namespace = kubernetes_namespace.consul.metadata[0].name
  }

  spec {
    selector = {
      app = "consul"
    }

    port {
      name        = "http"
      port        = 8500
      target_port = 8500
    }

    port {
      name        = "dns"
      port        = 8600
      target_port = 8600
    }

    type = "NodePort"
  }
}
