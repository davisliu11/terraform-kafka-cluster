resource "aws_vpc" "default" {
  cidr_block       = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "${var.project}-default-vpc"
  }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
}

resource "aws_route_table" "default" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {
        Name = "${var.project} Route Table"
    }
}

resource "aws_subnet" "default" {
    count    = "${length(var.subnet_cidrs)}"
    vpc_id   = "${aws_vpc.default.id}"

    cidr_block = "${var.subnet_cidrs[count.index]}"
    availability_zone = "${var.availability_zones[count.index]}"

    tags {
        Name = "${var.project} Subnet ${count.index}"
    }
}

resource "aws_route_table_association" "default" {
    count          = "${length(var.subnet_cidrs)}"
    subnet_id      = "${aws_subnet.default.*.id[count.index]}"
    route_table_id = "${aws_route_table.default.id}"
}