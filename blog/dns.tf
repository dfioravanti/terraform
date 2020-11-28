data "aws_route53_zone" "top_domain" {
  name = local.domain_name
}
