variable "hostname_prefix" {
  default = "vpn-do"
}

variable "droplet_username" {
  default = "vpn"
}

variable "digitalocean_region" {
  default = "ams3"
}

variable "disk_size" {
  default = "10Gi"
}

variable "private_ssh_path" {
  default = "~/.ssh/id_rsa"
}

variable "public_ssh_path" {
  default = "~/.ssh/id_rsa.pub"
}