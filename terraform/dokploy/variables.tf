variable "hcloud_token" {
  description = "Hetzner Cloud API token."
  type        = string
  sensitive   = true
}

variable "ssh_key_ids" {
  description = "Hetzner SSH key IDs allowed to access the server."
  type        = list(string)
}

variable "allowed_admin_cidrs" {
  description = "CIDR blocks allowed to access SSH and the Dokploy admin panel."
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
