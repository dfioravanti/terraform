

resource "aws_s3_bucket" "website_bucket" {
  bucket = local.domain_name
  policy = data.aws_iam_policy_document.website_policy.json
  website {
    index_document = "index.html"
    error_document = "404.html"
  }
  tags = {
    Name = local.domain_name
  }
}

resource "aws_s3_bucket_public_access_block" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "website_logs_bucket" {
  bucket = "${local.domain_name}-logs"

  tags = {
    Name = "${local.domain_name}-logs"
  }
}

resource "aws_s3_bucket_public_access_block" "website_logs_bucket" {
  bucket = aws_s3_bucket.website_logs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "website_policy" {
  statement {
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = [aws_cloudfront_origin_access_identity.blog.iam_arn]
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${local.domain_name}/*"
    ]
  }
}