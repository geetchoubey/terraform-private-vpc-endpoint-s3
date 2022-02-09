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
  user_data = file("scripts/ssm-user-data.sh")

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

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.ec2_role.name
}

/*
Policy for enabling VPC Endpoint and SSM

resource "aws_iam_policy" "endpoints_s3_policy" {
  name   = "endpoints-s3-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.endpoints_s3_policy.json
}
resource "aws_iam_role_policy_attachment" "endpoints_s3_policy-attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.endpoints_s3_policy.arn
}

data "aws_iam_policy_document" "endpoints_s3_policy" {
  statement {
    effect = "Allow"

    actions = ["s3:GetObject"]
    resources = [
      "arn:aws:s3:::aws-ssm-${var.region}*//*",
      "arn:aws:s3:::aws-windows-downloads-${var.region}*//*",
      "arn:aws:s3:::amazon-ssm-${var.region}*//*",
      "arn:aws:s3:::amazon-ssm-packages-${var.region}*//*",
      "arn:aws:s3:::${var.region}-birdwatcher-prod*//*",
      "arn:aws:s3:::patch-baseline-snapshot-${var.region}*//*"
    ]
  }
}*/

resource "aws_iam_policy" "s3_policy" {
  name   = "s3-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.s3_policy.json
}
resource "aws_iam_role_policy_attachment" "s3_policy-attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    effect = "Allow"
    actions = ["s3:*"]
    resources = ["*"]
  }
}