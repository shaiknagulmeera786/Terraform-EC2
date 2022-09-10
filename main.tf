provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.aws_region}"
}

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags = {
        Name = "${var.vpc_name}"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
        tags = {
        Name = "${var.IGW_name}"
    }
}

resource "aws_subnet" "subnet-public" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "us-east-1a"

    tags = {
        Name = "${var.public_subnet_name}"
    }
}


resource "aws_route_table" "rt-tf" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags = {
        Name = "${var.Main_Routing_Table}"
    }
}

resource "aws_route_table_association" "rt-tf" {
    subnet_id = "${aws_subnet.subnet-public.id}"
    route_table_id = "${aws_route_table.rt-tf.id}"
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    }
}


resource "aws_instance" "ec2" {
    ami = "${lookup(var.amis, var.aws_region)}"
    availability_zone = "us-east-1a"
    instance_type = "t2.nano"
    key_name = "${var.key_name}"
    subnet_id = "${aws_subnet.subnet-public.id}"
    vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
    associate_public_ip_address = true
    tags = {
        Name = "ec2-tf"
        Env = "test"
        Owner = "nagulmeera"
    }
}
