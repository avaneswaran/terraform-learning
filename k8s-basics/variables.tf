variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "dev"
}

variable "replicas" {
  description = "Number of pod replicas"
  type        = number
  default     = 3
}

variable "app_name" {
  description = "Application name"
  type        = string
  default     = "nginx"
}
