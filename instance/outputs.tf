# output "public_ip" {
#   value       = tencentcloud_instance.cvm.public_ip
#   description = "The public IP of the Instance"
# }



output "lb_id" {
  value = "${tencentcloud_clb_instance.load_balancer.id}"
}


output "instance_private_ip_addresses" {
  # Result is a map from instance id to private IP address, such as:
  #  {"i-1234" = "192.168.1.2", "i-5678" = "192.168.1.5"}
  value = {
    for instance in tencentcloud_instance.cvm:
    instance.id => instance.private_ip
  }
}


output "instance_public_ip_addresses" {
  value = {
    for instance in tencentcloud_instance.cvm:
    instance.id => instance.public_ip
    if instance.allocate_public_ip
  }
}


output "instances_by_availability_zone" {
  #  {"us-east-1a": ["i-1234", "i-5678"]}
  value = {
    for instance in tencentcloud_instance.cvm:
    instance.availability_zone => instance.id...
  }
}