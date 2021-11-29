resource "aws_default_vpc" "default_vpc" {

}

resource "aws_default_subnet" "default_subnet_a" {
  availability_zone = "${var.region_primary}a"
}

resource "aws_default_subnet" "default_subnet_b" {
  availability_zone = "${var.region_primary}b"
}

resource "aws_default_subnet" "default_subnet_c" {
  availability_zone = "${var.region_primary}c"
}