variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "eu-central-1"
}

variable "amis" {
  type = map(string)
  default = {
    eu-central-1 = "ami-0b418580298265d5c"
    us-east-1    = "ami-07ebfd5b3428b6f4d"
  }
}

variable "instance_type" {
  default = "t2.large"
}

variable "bucket_name" {
  default = "jh-storage"
}
