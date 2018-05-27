output "chef-ip" {
  value = "${aws_instance.chef.public_ip}"
}
