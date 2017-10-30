resource "aws_security_group" "ssh" {
  name        = "ssh_security_group"
  description = "Allow ssh traffic"
  vpc_id      = "${data.terraform_remote_state.static.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "ssh_security_group"
  }
}

resource "aws_security_group" "kafka" {
  name        = "kafka_security_group"
  description = "Allow kafka traffic"
  vpc_id      = "${data.terraform_remote_state.static.vpc_id}"

  ingress {
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "kafka_security_group"
  }
}

resource "aws_security_group" "zookeeper" {
  name        = "zookeeper_security_group"
  description = "Allow zookeeper traffic"
  vpc_id      = "${data.terraform_remote_state.static.vpc_id}"

  # port 31995 as well maybe
  ingress {
    from_port   = 2181
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 31995
    to_port     = 31995
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "zookeeper_security_group"
  }
}