resource "aws_instance" "jh" {
  ami                    = lookup(var.amis, var.aws_region)
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.instance.id]
  iam_instance_profile   = aws_iam_instance_profile.jh.name

  user_data = templatefile("script/install.sh", {
    aws_region = var.aws_region
    bucket_name = var.bucket_name
    password = var.jh_password
  })

  tags = {
    Name = "jh"
  }
}

resource "aws_security_group" "instance" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jh"
  }
}

resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  # lifecycle {
  #   prevent_destroy = true
  # }

  tags = {
    Name = "jh"
  }
}

resource "aws_iam_role" "jh" {
  name               = "jh_role"
  assume_role_policy = data.aws_iam_policy_document.sts.json

  tags = {
    Name = "jh"
  }
}

resource "aws_iam_instance_profile" "jh" {
  role = aws_iam_role.jh.name
}

resource "aws_iam_role_policy" "jh" {
  role   = aws_iam_role.jh.id
  policy = data.aws_iam_policy_document.s3.json
}
