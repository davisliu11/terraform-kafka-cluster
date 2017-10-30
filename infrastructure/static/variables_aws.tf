variable "region" {
  default = "us-west-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "availability_zones" {
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "project" {
  default = "confluent"
}

variable "route53_hosted_zone_name" {
  default = "youku.co.nz"
}

output "vpc_id" {
  value = "${aws_vpc.default.id}"
}

output "hosted_zone_id" {
  value = "${aws_route53_zone.default.zone_id}"
}

output "hosted_zone_name" {
  value = "${aws_route53_zone.default.name}"
}

output "subnet_ids" {
  value = ["${aws_subnet.default.*.id}"]
}

output "kafka_iam_role_name" {
  value = "${aws_iam_role.default.name}"
}



