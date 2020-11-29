locals {
  s3_origin_id = "S3BucketOrigin"
}

resource "aws_cloudfront_origin_access_identity" "blog" {
  comment = "cloudfront origin access identity"
}

# IMPORTANT: if you do something that changes the id of the distribution then you need to 
# update this id config file of the website
resource "aws_cloudfront_distribution" "blog" {
  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.blog.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = aws_s3_bucket.website_logs_bucket.bucket_domain_name
  }

  aliases = ["www.dfioravanti.com"]

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # All cloudfront nodes
  price_class = "PriceClass_All"

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.top_domain.id
    minimum_protocol_version = "TLSv1.2_2019"
    ssl_support_method       = "sni-only"
  }

  tags = {
    Environment = "production"
    Name        = "blog"
  }

}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.top_domain.zone_id
  name    = "www"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.blog.domain_name
    zone_id                = aws_cloudfront_distribution.blog.hosted_zone_id
    evaluate_target_health = false
  }
}