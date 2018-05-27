resource "aws_subnet" "1" {
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "ap-northeast-1a"
  cidr_block = "${var.cidr_prefix}.1.0/24"

  tags = {
    Name = "${var.project}"
  }
}

resource "aws_subnet" "2" {
  vpc_id = "${aws_vpc.main.id}"
  availability_zone = "ap-northeast-1c"
  cidr_block = "${var.cidr_prefix}.2.0/24"

  tags = {
    Name = "${var.project}"
  }
}

resource "aws_route_table_association" "subnet_1" {
  subnet_id      = "${aws_subnet.1.id}"
  route_table_id = "${aws_route_table.main.id}"
}

resource "aws_route_table_association" "subnet_2" {
  subnet_id      = "${aws_subnet.2.id}"
  route_table_id = "${aws_route_table.main.id}"
}
