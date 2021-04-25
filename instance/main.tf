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
}


