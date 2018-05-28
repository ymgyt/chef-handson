provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

terraform {
  backend "s3" {
    # bucket = "${var.backend_bucket}"   # key    = "${var.backend_key}"  # region = "${var.region}"
  }
}
