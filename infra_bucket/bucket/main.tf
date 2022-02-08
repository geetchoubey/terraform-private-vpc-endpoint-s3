resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id
  policy = data.aws_iam_policy_document.my_s3_bucket_policy_for_secondary_account.json
}

data aws_iam_policy_document "my_s3_bucket_policy_for_secondary_account" {
  statement {
    principals {
      identifiers = [var.secondary_aws_account]
      type        = "AWS"
    }
    actions = [
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = [
      aws_s3_bucket.my_bucket.arn,
      "${aws_s3_bucket.my_bucket.arn}/*",
    ]
  }
}