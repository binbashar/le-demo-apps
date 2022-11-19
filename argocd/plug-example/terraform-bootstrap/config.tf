provider "kubernetes" {
  host                   = var.kubernetes_host
  cluster_ca_certificate = base64decode(var.kubernetes_cluster_ca_certificate)
  client_key             = base64decode(var.kubernetes_client_key)
  client_certificate     = base64decode(var.kubernetes_client_certificate)
}

provider "helm" {
  kubernetes {
    host                   = var.kubernetes_host
    cluster_ca_certificate = base64decode(var.kubernetes_cluster_ca_certificate)
    client_key             = base64decode(var.kubernetes_client_key)
    client_certificate     = base64decode(var.kubernetes_client_certificate)
  }
}

terraform {
  required_version = ">= 1.1.3"

  required_providers {
    helm       = "~> 2.5"
    kubernetes = "~> 2.10"
  }
}
