resource "aws_instance" "public_instance" {
  ami                         = var.ami
  instance_type               = "t2.micro"
  subnet_id                   = var.public_subnet_id
  security_groups             = [var.public_sg]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true
  tags                        = {
    Name = "Public Instance"
  }
}

resource "aws_instance" "private_instance" {
  ami                  = var.ami
  instance_type        = "t2.micro"
  subnet_id            = var.private_subnet_id
  security_groups      = [var.private_sg]
  key_name             = var.key_pair_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  tags                 = {
    Name = "Private Instance"
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2_s3_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags               = {
    Name = "my_ec2_role"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role_policy" "ec2_role_policy" {
  role   = aws_iam_role.ec2_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

