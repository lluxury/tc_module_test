terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      version = "1.56.1"
    }
  }
}


#get specified zone configs 
# data "tencentcloud_mysql_zone_config" "zone_config" {
#   region             = var.tc_region
# }

#create a main mysql instance with intranet service 
resource "tencentcloud_mysql_instance" "main" {
  mem_size          = var.tc_mem_size
  volume_size       = var.tc_volume_size
  instance_name     = var.tc_main_mysql_name
  engine_version    = var.tc_engine_version
  root_password     = var.tc_mysql_password
  availability_zone = var.tc_az
  project_id        = var.tc_project_id
  internet_service  = 1
  slave_sync_mode   = 1
  intranet_port     = var.tc_mysql_intranet_port

  vpc_id  = "${var.tc_vpc_id }"
  subnet_id = "${var.tc_subnet_id}"
  security_groups = ["${var.tc_security_group_id}"]


  parameters = {
    max_connections = var.tc_max_connections
  }
}


#create the account of the main mysql instance
resource "tencentcloud_mysql_account" "mysql_account" {
  mysql_id    = tencentcloud_mysql_instance.main.id
  name        = var.tc_account_name
  password    = var.tc_account_password
  description = var.tc_account_description
}
