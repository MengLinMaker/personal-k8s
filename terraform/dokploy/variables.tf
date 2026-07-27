variable "hcloud_token" {
  description = "Hetzner Cloud API token."
  type        = string
  sensitive   = true
}

variable "tailscale_auth_key" {
  description = "Tailscale auth key used to join the Dokploy server to the tailnet and advertise the Dokploy Docker subnet."
  type        = string
  sensitive   = true
}

variable "allowed_admin_cidrs" {
  description = "CIDR blocks allowed to access the Dokploy admin panel."
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
