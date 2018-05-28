data "aws_route53_zone" "main" {
  name         = "${var.domain}"
  private_zone = false
}

resource "aws_route53_record" "chef" {
  zone_id = "${data.aws_route53_zone.main.id}"
  name    = "${var.host}.${var.domain}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.chef.public_ip}"]
}
