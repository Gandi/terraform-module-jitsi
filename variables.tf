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