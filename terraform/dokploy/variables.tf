variable "hcloud_token" {
  description = "Hetzner Cloud API token."
  type        = string
  sensitive   = true
}

variable "ssh_key_ids" {
  description = "Optional Hetzner SSH key IDs allowed to access the server. Leave empty to disable normal SSH bootstrap access."
  type        = list(string)
  default     = []
}

variable "allowed_admin_cidrs" {
  description = "CIDR blocks allowed to access the Dokploy admin panel, and SSH when ssh_key_ids is not empty."
  type        = list(string)
}

variable "labels" {
  description = "Labels applied to Hetzner resources."
  type        = map(string)
  default = {
    project = "personal-infra"
    role    = "dokploy"
  }
}
