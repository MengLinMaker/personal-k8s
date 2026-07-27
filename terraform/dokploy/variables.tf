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

variable "tailscale_auth_key" {
  description = "Optional Tailscale auth key used to join the server to the tailnet during cloud-init."
  type        = string
  default     = null
  sensitive   = true

  validation {
    condition     = var.tailscale_auth_key == null || trimspace(var.tailscale_auth_key) != ""
    error_message = "tailscale_auth_key must be null or a non-empty string."
  }
}

variable "enable_tailscale" {
  description = "Whether cloud-init should install Tailscale and join the server to your tailnet."
  type        = bool
  default     = false
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
