data "terraform_remote_state" "static" {
  backend = "local"

  config {
    path = "${path.module}/static/terraform.tfstate"
  }
}

variable "amis" {
  type = "map"

  default = {
    ap-southeast-2 = "ami-8536d6e7"
    us-west-2 = "ami-e689729e"
  }
}

variable "region" {
  default = "us-west-2"
}

variable "zookeeper_instance_type" {
  default = "t2.micro"
}

variable "kafka_instance_type" {
  default = "t2.small"
}

variable "availability_zones" {
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}