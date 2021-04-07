provider "aws" {
  region = "ap-northeast-1"
  # endpoints {
  #   sts = "https://sts.ap-northeast-1.amazonaws.com"
  # }
}

resource "aws_s3_bucket" "procochanLogsReceiver" {
  bucket = "log-receiver"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_public_access_block" "procochanLogsReceiver" {
  bucket = aws_s3_bucket.procochanLogsReceiver.id

  block_public_acls   = true
  block_public_policy = true
  restrict_public_buckets = true
  ignore_public_acls = true
}

resource "aws_s3_bucket_policy" "receiverBucketPolicy" {
  bucket=aws_s3_bucket.procochanLogsReceiver.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "logs.ap-northeast-1.amazonaws.com"
        }
        Action    = ["s3:GetBucketAcl","s3:PutObject"]
        Resource = [
          aws_s3_bucket.procochanLogsReceiver.arn,
          "${aws_s3_bucket.procochanLogsReceiver.arn}/*",
        ]
      },
    ]
  })
}