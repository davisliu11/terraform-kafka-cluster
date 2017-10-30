data "aws_route53_zone" "main" {
  name      = "${var.route53_hosted_zone_name}."
}

resource "aws_route53_zone" "default" {
  name = "${var.project}.${var.route53_hosted_zone_name}."

  tags {
    project = "${var.project}"
  }
}

resource "aws_route53_record" "default-ns" {
  zone_id = "${data.aws_route53_zone.main.zone_id}"
  name    = "${var.project}.${var.route53_hosted_zone_name}"
  type    = "NS"
  ttl     = "30"

  records = [
    "${aws_route53_zone.default.name_servers.0}",
    "${aws_route53_zone.default.name_servers.1}",
    "${aws_route53_zone.default.name_servers.2}",
    "${aws_route53_zone.default.name_servers.3}",
  ]
}