variable "hcloud_token" {
  description = "Hetzner Cloud API token."
  type        = string
  sensitive   = true
}

variable "allowed_admin_cidrs" {
  description = "CIDR blocks allowed to access the Kubernetes and Talos APIs. Set this to your current public IP, e.g. [\"203.0.113.10/32\"]."
  type        = list(string)
}

variable "labels" {
  description = "Labels applied to Hetzner resources."
  type        = map(string)
  default = {
    project = "personal-k8s"
    role    = "base"
  }
}
