variable "dns_zone" {
  type = string
  description = "The DNS zone used by the gandi provider."
}

variable "dns_subdomain" {
  type = string
  description = "The subdomain used with the DNS zone by the gandi provider. This will be used to create an A and and AAAA record within the DNS zone that points to the virtual machine hosting the Jitsi instance."
}

variable "letsencrypt_email" {
  type = string
  description = "The email that Let's Encrypt will use for expiration notifications."
}

variable "letsencrypt_staging" {
  type = string
  default = "0"
  description = "Whether to use the Let's Encrypt staging platform. \"0\" Means not to use Let's Encrypt staging platform. \"1\" Means to use it. Useful for testing purposes as there is a rate limit on the production platform."
}

variable "server_name" {
  type = string
  default = "jitsi"
  description = "The name of the virtual machine to be created by Openstack."
}

variable "keypair_name" {
  type = string
  default = "jitsi-keypair"
  description = "The name of the ssh keypair to be created by Openstack."
}