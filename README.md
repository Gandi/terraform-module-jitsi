# terraform-gandi-jitsi

Terraform module that installs a [Jitsi](https://meet.jit.si/) instance on a newly created
Openstack virtual machine on GandiCloud VPS infrastructure.
The Jitsi instance will use Let's Encrypt to generate a certificate.

This module uses the [openstack](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs) and [gandi](https://registry.terraform.io/providers/psychopenguin/gandi/latest/docs) providers. Please refer to their respective documentation for usage and configuration.

The Openstack provider will create the SSH key and the virtual machine using Ubuntu 20.04 as the base system image and initialize it with the SSH key and a Cloud-Init file that will install Jitsi onto the virtual machine.

The Gandi provider will create LiveDNS records that will point to the virtual machine IP addresses.

## Usage
```hcl
# Define required providers
terraform {
  required_version = ">= 1.0"
}

provider "openstack" {
  auth_url = "https://keystone.sd6.api.gandi.net:5000/v3"
  region = "FR-SD6"
}

provider "gandi" {}

# Use gandi/jitsi module
module "gandi-jitsi" {
    source = "gandi/jitsi"
    server_name = "gandi-jitsi"
    keypair_name = "module-jitsi"
    letsencrypt_email = "email@example.com"
    dns_subdomain = "jitsi"
    dns_zone = "example.com"
}

output "ssh" {
  value = module.gandi-jitsi.ssh_cmd
}

output "url" {
  value = module.gandi-jitsi.https_address
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="server_name"></a> [server_name](#server\_name) | The name of the virtual machine used by Openstack. | `string` | "jitsi" | no |
| <a name="keypair_name"></a> [keypair_name](#keypair\_name) | The name of the ssh keypair to be created by Openstack. It must not exist. | `string` | "jitsi-keypair" | no |
| <a name="letsencrypt_email"></a> [letsencrypt_email](#letsencrypt\_email) | The email that Let's Encrypt will use for expiration notifications. | `string` | n/a | yes |
| <a name="letsencrypt_staging"></a> [letsencrypt_staging](#letsencrypt\_staging) | "0" Means not to use Let's Encrypt staging platform. "1" Means to use it. Useful for testing purposes as there is a rate limit on the production platform. | `string` | "0" | no |
| <a name="dns_subdomain"></a> [dns_subdomain](#dns\_subdomain) | The subdomain used with the DNS zone by the gandi provider. This will create an A and and AAAA record that points to the virtual machine hosting the Jitsi instance. | `string` | n/a | yes |
| <a name="dns_zone"></a> [dns_zone](#dns\_zone) | The DNS zone used by the gandi provider. | `string` | n/a | yes |


## Outputs

| Name | Description |
|------|-------------|
| <a name="ssh_cmd"></a> [ssh_cmd](#ssh\_cmd) | The ssh command to use to connect to the virtual machine |
| <a name="IP_v4"></a> [IP_v4](#IP\_v4) | The virtual machine's IP v4 |
| <a name="IP_v6"></a> [IP_v6](#IP\_v6) | The virtual machine's IP v6 |
| <a name="https_address"></a> [https_address](#https\_address) | The URL of the Jitsi using https |


## Requirements

| Name | Version |
|------|---------|
| <a name="terraform"></a> [terraform](#terraform) | ~> 1.0 |
| <a name="openstack"></a> [openstack](#openstack) | ~> 1.35.0 |
| <a name="gandi"></a> [gandi](#gandi) | 2.0.0-rc3 |




