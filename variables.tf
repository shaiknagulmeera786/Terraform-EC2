variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {}
variable "amis" {
    default = {
        us-east-1 = "ami-05fa00d4c63e32376" # Amazon Linux 2 AMI (HVM)
    }
}
variable "vpc_cidr" {}
variable "vpc_name" {}
variable "IGW_name" {}
variable "key_name" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "public_subnet_name" {}
variable "private_subnet_name" {}
variable Main_Routing_Table {}
variable "azs" {
  description = "Run the EC2 Instances in these Availability Zones"
  default = "us-east-1a"
}
variable "environment" { default = "dev" }
variable "instance_type" {
  default = "t2.micro"
}

