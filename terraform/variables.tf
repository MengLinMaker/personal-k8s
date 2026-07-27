variable "hcloud_token" {
  description = "Hetzner Cloud API token."
  type        = string
  sensitive   = true
}

variable "ssh_key_ids" {
  description = "Existing Hetzner SSH key IDs/names to attach to the server."
  type        = list(string)
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to access SSH. Set this to your current public IP, e.g. [\"203.0.113.10/32\"]."
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
