output "public_ip" {
  value       = tencentcloud_instance.cvm.public_ip
  description = "The public IP of the Instance"
}

output "lb_id" {
  value = "${tencentcloud_clb_instance.load_balancer.id}"
}