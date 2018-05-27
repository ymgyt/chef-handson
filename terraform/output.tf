output "chef" {
  value = "${aws_route53_record.chef.fqdn}"
}
