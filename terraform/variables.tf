variable "hcloud_token" {
  description = "Hetzner Cloud API token."
  type        = string
  sensitive   = true
}

variable "server_name" {
  description = "Name for the Hetzner server."
  type        = string
  default     = "personal-k8s-node-1"
}

variable "server_type" {
  description = "Hetzner server type. CPX12 is 1 vCPU x86 / 2GB RAM / 40GB disk."
  type        = string
  default     = "cpx12"
}

variable "location" {
  description = "Hetzner location. fsn1 is Falkenstein, Germany; nbg1 is Nuremberg, Germany."
  type        = string
  default     = "fsn1"
}

variable "image" {
  description = "Initial boot image. Replace with a Talos x86 snapshot/image once Talos provisioning is added."
  type        = string
  default     = "ubuntu-24.04"
}

variable "ssh_public_key" {
  description = "Public SSH key material to register in Hetzner and attach to the server. Leave null to use ssh_key_ids."
  type        = string
  default     = null
}

variable "ssh_key_ids" {
  description = "Existing Hetzner SSH key IDs/names to attach when ssh_public_key is null."
  type        = list(string)
  default     = []
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
