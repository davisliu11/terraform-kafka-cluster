data "template_file" "user_data_kafka" {
  template = "${file("app_install.tpl")}"
  vars {
    app_type = "kafka",
    zookeeper_ips = "${join(":2181,", aws_instance.zookeeper.*.private_ip)}:2181",
    hosted_zone_id = "${data.terraform_remote_state.static.hosted_zone_id}",
    hosted_zone_name = "${data.terraform_remote_state.static.hosted_zone_name}"
  }
}

data "template_file" "user_data_zookeeper" {
  template = "${file("app_install.tpl")}"
  vars {
    app_type = "zookeeper",
    zookeeper_ips = "",
    hosted_zone_id = "",
    hosted_zone_name = ""
  }
}