terraform {
  required_version = ">= 1.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.35.0"
    }
    gandi = {
      source  = "psychopenguin/gandi"
      version = "2.0.0-rc3"
    }
  }
}

provider "openstack" {
  auth_url = "https://keystone.sd6.api.gandi.net:5000/v3"
  region   = "FR-SD6"
}

provider "gandi" {}


module "gandi-jitsi" {
  source              = "../.."
  server_name         = "gandi-jitsi"
  keypair_name        = "module-jitsi-test"
  letsencrypt_email   = "email@example.invalid"
  letsencrypt_staging = "1"
  dns_subdomain       = var.DNS_SUBDOMAIN
  dns_zone            = var.DNS_ZONE
}

variable "DNS_SUBDOMAIN" {
  type = string
}

variable "DNS_ZONE" {
  type = string
}