resource "aws_instance" "zookeeper" {
  count         = "${var.zookeeper_cluster_size}"
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "${var.zookeeper_instance_type}"
  key_name      = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = ["${aws_security_group.ssh.id}", "${aws_security_group.zookeeper.id}"]
  subnet_id     = "${data.terraform_remote_state.static.subnet_ids[count.index]}"
  user_data     = "${data.template_file.user_data_zookeeper.rendered}"
  associate_public_ip_address = true
  tags {
    Name = "${var.project}-zookeeper",
    project = "${var.project}"
  }
}
