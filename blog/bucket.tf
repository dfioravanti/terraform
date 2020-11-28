
provider "aws" {
  profile = "blog"
  region  = "eu-central-1"
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = local.domain_name
  acl = "public-read"
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
  acl = "private"

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
      identifiers = ["*"]
      type = "AWS"
    }
    resources = [
      "arn:aws:s3:::${local.domain_name}/*"
    ]
  }
}