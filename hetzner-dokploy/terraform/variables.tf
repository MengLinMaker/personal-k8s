variable "hcloud_token" {
  description = "Hetzner Cloud API token."
  type        = string
  sensitive   = true
}

variable "tailscale_auth_key" {
  description = "Tailscale auth key used to join the Dokploy server to the tailnet and advertise the Dokploy Docker subnet."
  type        = string
  sensitive   = true

  validation {
    condition     = startswith(var.tailscale_auth_key, "tskey-auth-")
    error_message = "tailscale_auth_key must be a Tailscale auth key that starts with tskey-auth-, not a Tailscale API key."
  }
}

variable "allowed_admin_cidrs" {
  description = "CIDR blocks allowed to access SSH and the Dokploy admin panel."
  type        = list(string)
}

variable "ssh_public_key" {
  description = "Public SSH key allowed to log in as root on the Dokploy server."
  type        = string
}

variable "labels" {
  description = "Labels applied to Hetzner resources."
  type        = map(string)
  default = {
    project = "personal-infra"
    role    = "dokploy"
  }
}
