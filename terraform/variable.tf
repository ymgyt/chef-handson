variable access_key {
  description = "aws iam user access key"
}

variable secret_key {
  description = "aws iam user secret key"
}

variable project {
  default = "chef-handson"
}

variable cidr_prefix {
  default = "10.0"
}
variable chef_ami_id {
  # ubuntu 14.04 LTS amd64 hvm:ebs-ssd
  # https://cloud-images.ubuntu.com/locator/ec2/
  default = "ami-1450ad6b"
}

variable chef_instance_type {
  default = "t2.medium"
}

variable chef_key_name {
  description = "ssh key pair name"
}

variable chef_allowed_ips  {
  default = "0.0.0.0/0"
}
