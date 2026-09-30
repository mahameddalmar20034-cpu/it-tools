resource "aws_acm_certificate" "it-tools" {
  domain_name       = var.modalmar.co.uk
  validation_method = "DNS"

  tags = {
    Environment = "it-tools-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "cloudlflare_dns_record" "it-tools" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

 
  name            = each.value.name
  content         = "each.value.record
  ttl             = 60
  type            = each.value.type
  zone_id         = var.cloudlflare_zone_id
}




resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.example.arn
  validation_record_fqdns = [for record in aws_route53_record.example : record.fqdn]
}