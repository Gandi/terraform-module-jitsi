output "ssh_cmd" {
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