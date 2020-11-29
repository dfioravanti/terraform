
resource "aws_acm_certificate" "top_domain" {
  domain_name       = "*.${local.domain_name}"
  validation_method = "DNS"

  tags = {
    Website = ""
  }

  # We need the certificate in the "us-east-1" region
  provider = aws.virginia
}

resource "aws_route53_record" "top_domain_validation" {
  for_each = {
    for dvo in aws_acm_certificate.top_domain.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.top_domain.zone_id
}

resource "aws_acm_certificate_validation" "top_domain" {
  certificate_arn         = aws_acm_certificate.top_domain.arn
  validation_record_fqdns = [for record in aws_route53_record.top_domain_validation : record.fqdn]

  # We need the certificate in the "us-east-1" region
  provider = aws.virginia
}