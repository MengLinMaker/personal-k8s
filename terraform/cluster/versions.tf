terraform {
  required_version = ">= 1.12.0, < 2.0.0"

  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "3.6.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "3.2.0"
    }

    kubectl = {
      source  = "alekc/kubectl"
      version = "2.4.1"
    }
  }
}
