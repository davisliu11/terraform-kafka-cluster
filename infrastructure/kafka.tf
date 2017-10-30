resource "aws_iam_instance_profile" "kafka_profile" {
    name = "kafka_profile"
    role = "${data.terraform_remote_state.static.kafka_iam_role_name}"
}

resource "aws_launch_configuration" "kafka_lc" {
  name          = "kafka-config"
  image_id      = "${lookup(var.amis, var.region)}"
  instance_type = "${var.kafka_instance_type}"
  key_name      = "${aws_key_pair.deployer.key_name}"
  security_groups = ["${aws_security_group.ssh.id}", "${aws_security_group.kafka.id}"]
  user_data     = "${data.template_file.user_data_kafka.rendered}"
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.kafka_profile.id}"
}

resource "aws_autoscaling_group" "kafka_asg" {
  availability_zones        = "${var.availability_zones}"
  name                      = "${var.project}-kafka-asg"
  max_size                  = "${var.kafka_cluster_size}"
  min_size                  = "${var.kafka_cluster_size}"
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = "${var.kafka_cluster_size}"
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.kafka_lc.name}"
  vpc_zone_identifier       = ["${data.terraform_remote_state.static.subnet_ids}"]

  tags = [{
    key                 = "Name"
    value               = "${var.project}-kafka"
    propagate_at_launch = true
  },{
    key                 = "project"
    value               = "${var.project}"
    propagate_at_launch = true
  }]
}

