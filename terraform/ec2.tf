resource "aws_instance" "chef" {
  ami                         = "${var.chef_ami_id}"
  instance_type               = "${var.chef_instance_type}"
  key_name                    = "${var.chef_key_name}"
  subnet_id                   = "${aws_subnet.1.id}"
  associate_public_ip_address = true

  vpc_security_group_ids = [
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_all_outbount.id}",
    "${aws_security_group.allow_https.id}",
  ]

  user_data = "${data.template_file.user_data.rendered}"

  tags {
    Name = "chef"
  }
}

resource "aws_eip" "chef" {
  instance   = "${aws_instance.chef.id}"
  vpc        = true
  depends_on = ["aws_internet_gateway.main"]
}

data "template_file" "user_data" {
  template = "${file("${path.module}/templates/user_data.sh.tpl")}"

  vars {
    hostname        = "${var.host}.${var.domain}"
    mackerel_apikey = "${var.mackerel_apikey}"
  }
}

resource "aws_security_group" "allow_all_outbount" {
  name        = "allow_all_outbount"
  description = "Allow all outbount traffic"
  vpc_id      = "${aws_vpc.main.id}"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = -1
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow specified ssh inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.chef_allowed_ips}"]
  }
}

resource "aws_security_group" "allow_https" {
  name        = "allow_https"
  description = "Allow https inbound traffic"
  vpc_id      = "${aws_vpc.main.id}"

  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
