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

resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
    labels = {
      managed_by = "terraform"
    }
  }
}

resource "kubernetes_deployment" "vault" {
  metadata {
    name      = "vault"
    namespace = kubernetes_namespace.vault.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "vault"
      }
    }

    template {
      metadata {
        labels = {
          app = "vault"
        }
      }

      spec {
        container {
          name  = "vault"
          image = "hashicorp/vault:1.15"

          args = ["server", "-dev", "-dev-root-token-id=root", "-dev-listen-address=0.0.0.0:8200"]

          port {
            container_port = 8200
          }

          env {
            name  = "VAULT_DEV_ROOT_TOKEN_ID"
            value = "root"
          }

          env {
            name  = "VAULT_ADDR"
            value = "http://127.0.0.1:8200"
          }

          security_context {
            capabilities {
              add = ["IPC_LOCK"]
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "vault" {
  metadata {
    name      = "vault"
    namespace = kubernetes_namespace.vault.metadata[0].name
  }

  spec {
    selector = {
      app = "vault"
    }

    port {
      port        = 8200
      target_port = 8200
    }

    type = "NodePort"
  }
}
