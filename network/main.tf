terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      version = "1.56.1"
    }
  }
}


# resource "tencentcloud_vpc" "vpc_base" {
#   name = "${var.tc_vpc_name}"
#   cidr_block = "${var.tc_vpc_cidr}"
# }

resource "tencentcloud_subnet" "subnet_pana2" {
  cidr_block = "${var.tc_subnet_cidr}"
  # vpc_id = "${tencentcloud_vpc.vpc_base.id}"
  vpc_id = "${var.tc_vpc_id}"
  
  name = "${var.tc_subnet_name}"
  availability_zone = "${var.tc_az}"
}

resource "tencentcloud_security_group" "security_group" {
  name = "${var.tc_security_group_name}"
  project_id = "${var.tc_project_id}"
}

resource "tencentcloud_security_group_lite_rule" "instance" {
  security_group_id = "${tencentcloud_security_group.security_group.id}"

  ingress = [
    "ACCEPT#0.0.0.0/0#22,80,8080#TCP",
    "DROP#8.8.8.8#80,90#UDP",
  ]

  egress = [
    "ACCEPT#0.0.0.0/0#ALL#ALL",
  ]
}