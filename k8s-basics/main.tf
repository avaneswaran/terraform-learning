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

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
    labels = {
      environment = "development"
      managed_by  = "terraform"
    }
  }
}

resource "kubernetes_namespace" "staging" {
  metadata {
    name = "staging"
    labels = {
      environment = "staging"
      managed_by  = "terraform"
    }
  }
}

module "nginx_dev" {
  source = "../modules/k8s-app"

  name       = "nginx"
  namespace  = kubernetes_namespace.dev.metadata[0].name
  image      = "nginx:latest"
  replicas   = 2
}

module "nginx_staging" {
  source = "../modules/k8s-app"

  name       = "nginx"
  namespace  = kubernetes_namespace.staging.metadata[0].name
  image      = "nginx:latest"
  replicas   = 1
}

module "httpd_dev" {
  source = "../modules/k8s-app"

  name       = "httpd"
  namespace  = kubernetes_namespace.dev.metadata[0].name
  image      = "httpd:latest"
  replicas   = 1
}
