locals {
  public_ssh  = trimspace(file(var.public_ssh_path))
  private_ssh = trimspace(file(var.private_ssh_path))
}

data "template_file" "droplet-bootstrap-sh" {
  template = file("${path.module}/data/droplet-bootstrap.sh")
  vars = {
    private_ssh_key = local.private_ssh
    public_ssh_key = local.public_ssh
    username = var.droplet_username
  }
}

data "template_cloudinit_config" "droplet-userdata" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/x-shellscript"
    filename     = "10-terraform-bootstrap"
    content      = "#!/bin/sh\necho -n '${base64gzip(data.template_file.droplet-bootstrap-sh.rendered)}' | base64 -d | gunzip | /bin/sh"
  }
}

data "digitalocean_image" "ubuntu" {
  slug = "ubuntu-20-04-x64"
}

data "digitalocean_sizes" "main" {
  filter {
    key    = "slug"
    values = ["s-1vcpu-1gb"]
  }
}


resource "random_id" "hostname_suffix" {
  keepers = {
    hostname_prefix = var.hostname_prefix
  }
  byte_length = 8
}

# Establish the digitalocean_droplet
# ===
resource "digitalocean_droplet" "droplet" {
  image              = data.digitalocean_image.ubuntu.id
  name               = "${random_id.hostname_suffix.keepers.hostname_prefix}-${random_id.hostname_suffix.hex}"
  region             = var.digitalocean_region
  size               = element(data.digitalocean_sizes.main.sizes, 0).slug
  // ssh_keys           = [ locals.public_ssh ]
  // resize_disk        = var.digitalocean_resize_disk
  // tags               = {
  //   "Name": "${random_id.hostname_suffix.keepers.hostname_prefix}-${random_id.hostname_suffix.hex}"
  //   "Region": var.digitalocean_region
  // }
  user_data          = data.template_cloudinit_config.droplet-userdata.rendered
}