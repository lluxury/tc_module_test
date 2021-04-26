# output "vpc_id" {
#   value = "${tencentcloud_vpc.vpc_base.id}"
# }

output "subnet_id" {
  value = "${tencentcloud_subnet.subnet_pana2.id}"
}

output "sg_id" {
  value = "${tencentcloud_security_group.security_group.id}"
}