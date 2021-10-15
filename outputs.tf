output "ssh_cmd" {
  value       = "To ssh into the server use: ssh -i ${local_file.private-key.filename} ubuntu@${openstack_compute_instance_v2.jitsi.access_ip_v4}"
  description = "The command to use to ssh into the virtual machine"
}

output "IP_v4" {
  value       = openstack_compute_instance_v2.jitsi.access_ip_v4
  description = "The IP v4 of the virtual machine"
}

output "IP_v6" {
  value       = trim("${openstack_compute_instance_v2.jitsi.access_ip_v6}", "[]")
  description = "The IP v6 of the virtual machine"
}

output "https_address" {
  value       = "https://${gandi_livedns_record.jitsi_dns_v4.name}.${gandi_livedns_record.jitsi_dns_v4.zone}"
  description = "The URL of the Jitsi instance"
}