
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

resource "aws_s3_bucket" "website_logs_bucket" {
  bucket = "${local.domain_name}-logs"

  tags = {
    Name = "${local.domain_name}-logs"
  }
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

  statement {
    actions = [
      "s3:ListBucket"
    ]
    principals {
      identifiers = [aws_cloudfront_origin_access_identity.blog.iam_arn]
      type        = "AWS"
    }
    resources = [
      "arn:aws:s3:::${local.domain_name}"
    ]
  }
}