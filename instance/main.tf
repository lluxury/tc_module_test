terraform {
  required_providers {
    tencentcloud = {
      source = "tencentcloudstack/tencentcloud"
      version = "1.56.1"
    }
  }
}


resource "tencentcloud_instance" "cvm" {
  count   = "${var.tc_cvm_number}"                   
  image_id = "${var.tc_image_id}"
  instance_type = "${var.tc_instance_type}"
  availability_zone = "${var.tc_az}"
  system_disk_type = "CLOUD_PREMIUM"
  # instance_charge_type = POSTPAID_BY_HOUR


  vpc_id  = "${var.tc_vpc_id }"
  subnet_id = "${var.tc_subnet_id}"

  project_id         = "${var.tc_project_id}"
  allocate_public_ip = "${var.tc_enable_public_ip}"
  security_groups = ["${var.tc_security_group_id}"]
  internet_max_bandwidth_out = "${var.tc_bandwidth_out}"
  user_data = "${var.tc_user_data}"
}


resource "tencentcloud_subnet" "lb_subnet" {
  name = "${var.tc_lb_subnet_name}"
  cidr_block = "${var.tc_lb_cidr}"
  vpc_id = "${var.tc_vpc_id}"
  availability_zone = "${var.tc_az}"


}

resource "tencentcloud_clb_instance" "load_balancer" {
  network_type = "INTERNAL"
  clb_name     = "${var.tc_lb_name}"
  project_id   = "${var.tc_project_id}"
  vpc_id       = "${var.tc_vpc_id}"
  subnet_id = "${tencentcloud_subnet.lb_subnet.id}"

}


resource "tencentcloud_clb_listener" "TCP_listener" {
  clb_id                     = "${tencentcloud_clb_instance.load_balancer.id}"
  listener_name              = "${var.tc_listener_name}"
  port                       = 80
  protocol                   = "TCP"
  health_check_switch        = true
  health_check_time_out      = 2
  health_check_interval_time = 5
  health_check_health_num    = 3
  health_check_unhealth_num  = 3
  # session_expire_time        = 30
  # scheduler                  = "WRR"
  # health_check_port          = 200
  # health_check_type          = "HTTP"
  # health_check_http_code     = 2
  # health_check_http_version  = "HTTP/1.0"
  # health_check_http_method   = "GET"
}


resource "tencentcloud_clb_attachment" "backend" {
  clb_id      = "${tencentcloud_clb_instance.load_balancer.id}"
  listener_id = "${tencentcloud_clb_listener.TCP_listener.listener_id}"

  dynamic "targets" {
    for_each = [for value in tencentcloud_instance.cvm: value.id]
    content {
      instance_id = targets.value
      port        = "${var.tc_backend_port}"
      weight      = 10
    }
  }
}




