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
    # Ubuntu 20.04
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