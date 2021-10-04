# Gandi-Jitsi terraform module

## Prerequisites

This module uses:

- Terraform ([install Terraform][1])
- A domain name registered with Gandi ([gandi.net](https://www.gandi.net/))
- A Gandi V5 API Key
- A GandiCloud VPS instance (it will be automatically created by Terraform)

In order for this Terraform recipe to succeed, it must be possible to create a GandiCloud VPS instance and to manage a domain name registered with Gandi.

Then use:

```bash
terraform init
```

to initiate the terraform workspace and install the modules and providers used here.

## How to use it

This terraform infrastructure description will deploy a Jitsi instance on a V-R4 GandiCloud VPS server using the Jitsi docker release.
In order for this Terraform manifest to work properly the following environment variables must be exported:

 - TF_VAR_letsencrypt_email: the email to provide to Let's Encrypt for notifications
 - TF_VAR_dns_zone: the domain name (eg: example.com)
 - TF_VAR_dns_subdomain: the subdomain (eg: visio)
 - TF_VAR_api_key: a Gandi V5 API Key
 - TF_VAR_sharing_id: the sharing ID of an organization that can manage the DNS zone of the domain name in order to create the A and AAAA records.

If any of those variable is missing terraform will ask for a value.

Optional environment variables:

 - TF_VAR_keypair_name: the keypair name in openstack to initialize the server with. If no keypair is provided, there will be no way to connect to the server via SSH. Default is set to null, so no keypair will be provided during the server creation process.
 - TF_VAR_letsencrypt_staging: whether or not to use Let's Encrypt staging environment. (1 uses staging, 0 uses production). Only the production environment will generate a valid SSL certificate. Default is set to 0 to use the production environment.

Another part of the setup is to provide the Openstack credentials needed to create the virtual machine, which can be obtained via an openrc file or using an Openstack authentication token.


To create a virtual machine and install Jitsi use:

```bash
terraform apply
```

and follow the instructions.

# Testing

It is possible to use the staging servers from Let's Encrypt in order to test the deployment.
In order to do this, simply export the following variable:

```
export TF_VAR_letsencrypt_staging=1
```

[1]: https://learn.hashicorp.com/tutorials/terraform/install-cli
