terraform {
required_version = ">= 1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
    gandi = {
      source = "psychopenguin/gandi"
      version = "2.0.0-rc3"
    }
  }
}

provider "openstack" {
  auth_url = "https://keystone.sd6.api.gandi.net:5000/v3"
  region = "FR-SD6"
}

provider "gandi" {
  key = var.api_key
  sharing_id = var.sharing_id
}

variable "api_key" {
  type = string
}

variable "sharing_id" {
  type = string
}

variable "dns_zone" {
  type = string
}

variable "dns_subdomain" {
  type = string
}

variable "letsencrypt_email" {
  type = string
}

variable "letsencrypt_staging" {
  type = string
  default = "0"
}

variable "server_name" {
  type = string
  default = "jitsi"
}

variable "keypair_name" {
  type = string
  default = "jitsi-keypair"
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/cloud-init.yaml")}"

  vars = {
    domain = "${var.dns_subdomain}.${var.dns_zone}"
    email = "${var.letsencrypt_email}"
    use_le_staging = "${var.letsencrypt_staging}"
  }
}

resource "openstack_compute_keypair_v2" "jitsi-keypair" {
  name = var.keypair_name
}

resource "openstack_compute_instance_v2" "jitsi" {
  name = "jitsi"
  key_pair = openstack_compute_keypair_v2.jitsi-keypair.name
  flavor_name = "V-R2"
  security_groups = ["default"]
  power_state = "active"
  network {
    name = "public"
  }

  user_data = "${data.template_file.user_data.rendered}"

  block_device {
    uuid = "47edd0a0-23ce-4ce5-9168-36de68990d1b"
    source_type           = "image"
    volume_size           = 25
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }
}

resource "local_file" "private-key" {
  content     = openstack_compute_keypair_v2.jitsi-keypair.private_key
  filename = "jitsi-priv.key"
  file_permission = "0600"
}

resource "gandi_livedns_record" "jitsi_dns_v4" {
  zone = var.dns_zone
  name = var.dns_subdomain
  type = "A"
  ttl = 1800
  values = ["${openstack_compute_instance_v2.jitsi.access_ip_v4}"]
}

resource "gandi_livedns_record" "jitsi_dns_v6" {
  zone = var.dns_zone
  name = var.dns_subdomain
  type = "AAAA"
  ttl = 1800
  values = [trim("${openstack_compute_instance_v2.jitsi.access_ip_v6}", "[]")]
}

output "SSH_cmd" {
  value = "To ssh into the server use: ssh -i ${local_file.private-key.filename} ubuntu@${openstack_compute_instance_v2.jitsi.access_ip_v4}"
}

output "IP_v4" {
  value = "${openstack_compute_instance_v2.jitsi.access_ip_v4}"
}

output "IP_v6" {
  value = trim("${openstack_compute_instance_v2.jitsi.access_ip_v6}", "[]")
}

output "https_address" {
  value = "https://${gandi_livedns_record.jitsi_dns_v4.name}.${gandi_livedns_record.jitsi_dns_v4.zone}"
}
