output "hostname" {
  description = "The hostname applied to this digitalocean-droplet."
  value = digitalocean_droplet.droplet.name
}

output "region" {
  description = "The digitalocean region-slug this digitalocean-droplet is running in."
  value = digitalocean_droplet.droplet.region
}

output "droplet_id" {
  description = "The droplet_id of this digitalocean-droplet."
  value = digitalocean_droplet.droplet.id
}

output "ipv4_address" {
  description = "The public IPv4 address of this digitalocean-droplet."
  value = digitalocean_droplet.droplet.ipv4_address
}