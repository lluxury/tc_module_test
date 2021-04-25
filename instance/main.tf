terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      version = "1.56.1"
    }
  }
}


resource "tencentcloud_instance" "cvm" {
  image_id = "${var.tc_image_id}"
  instance_type = "${var.tc_instance_type}"
  availability_zone = "${var.tc_az}"
  system_disk_type = "CLOUD_PREMIUM"
  
  project_id         = "${var.tc_project_id}"
  allocate_public_ip = "${var.tc_enable_public_ip}"
  # security_groups = "${var.tc_security_group_id}"
  internet_max_bandwidth_out = "${var.tc_bandwidth_out}"
  user_data = "${var.tc_user_data}"
}


output "public_ip" {
  value       = tencentcloud_instance.cvm.public_ip
  description = "The public IP of the Instance"
}