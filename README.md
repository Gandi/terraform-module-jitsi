# terraform-module-jitsi

Terraform module that installs a [Jitsi](https://meet.jit.si/) instance on a newly created
OpenStack virtual machine on GandiCloud VPS infrastructure.
The Jitsi instance will use Let's Encrypt to generate a certificate.

This module uses the [OpenStack](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs) and [gandi](https://registry.terraform.io/providers/psychopenguin/gandi/latest/docs) providers. Please refer to their respective documentation for usage and configuration.

The OpenStack provider will create the SSH key and the virtual machine using Ubuntu 20.04 as the base system image and initialize it with the SSH key and a Cloud-Init file that will install Jitsi onto the virtual machine.

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
module "jitsi" {
    source = "Gandi/jitsi/module"
    server_name = "gandi-jitsi"
    keypair_name = "module-jitsi"
    letsencrypt_email = "email@example.invalid"
    dns_subdomain = "jitsi"
    dns_zone = "example.invalid"
}

output "ssh" {
  value = module.jitsi.ssh_cmd
}

output "url" {
  value = module.jitsi.https_address
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_gandi"></a> [gandi](#requirement\_gandi) | 2.0.0-rc3 |
| <a name="requirement_openstack"></a> [openstack](#requirement\_openstack) | ~> 1.35.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_gandi"></a> [gandi](#provider\_gandi) | 2.0.0-rc3 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_openstack"></a> [openstack](#provider\_openstack) | ~> 1.35.0 |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Resources

| Name | Type |
|------|------|
| [gandi_livedns_record.jitsi_dns_v4](https://registry.terraform.io/providers/psychopenguin/gandi/2.0.0-rc3/docs/resources/livedns_record) | resource |
| [gandi_livedns_record.jitsi_dns_v6](https://registry.terraform.io/providers/psychopenguin/gandi/2.0.0-rc3/docs/resources/livedns_record) | resource |
| [local_file.private-key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [openstack_compute_instance_v2.jitsi](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_instance_v2) | resource |
| [openstack_compute_keypair_v2.jitsi-keypair](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_keypair_v2) | resource |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dns_subdomain"></a> [dns\_subdomain](#input\_dns\_subdomain) | The subdomain used with the DNS zone by the gandi provider. This will be used to create an A and and AAAA record within the DNS zone that points to the virtual machine hosting the Jitsi instance. | `string` | n/a | yes |
| <a name="input_dns_zone"></a> [dns\_zone](#input\_dns\_zone) | The DNS zone used by the gandi provider. | `string` | n/a | yes |
| <a name="input_keypair_name"></a> [keypair\_name](#input\_keypair\_name) | The name of the ssh keypair to be created by OpenStack. | `string` | `"jitsi-keypair"` | no |
| <a name="input_letsencrypt_email"></a> [letsencrypt\_email](#input\_letsencrypt\_email) | The email that Let's Encrypt will use for expiration notifications. | `string` | n/a | yes |
| <a name="input_letsencrypt_staging"></a> [letsencrypt\_staging](#input\_letsencrypt\_staging) | Whether to use the Let's Encrypt staging platform. "0" Means not to use Let's Encrypt staging platform. "1" Means to use it. Useful for testing purposes as there is a rate limit on the production platform. | `string` | `"0"` | no |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | The name of the virtual machine to be created by OpenStack. | `string` | `"jitsi"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_IP_v4"></a> [IP\_v4](#output\_IP\_v4) | The IP v4 of the virtual machine |
| <a name="output_IP_v6"></a> [IP\_v6](#output\_IP\_v6) | The IP v6 of the virtual machine |
| <a name="output_https_address"></a> [https\_address](#output\_https\_address) | The URL of the Jitsi instance |
| <a name="output_ssh_cmd"></a> [ssh\_cmd](#output\_ssh\_cmd) | The command to use to ssh into the virtual machine |
