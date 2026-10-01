resource "aws_acm_certificate" "it-tools" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name = "it-tools-cert"
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "cloudflare_dns_record" "it-tools" {
  for_each = {
    for dvo in aws_acm_certificate.it-tools.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type

    }
  }


  name    = each.value.name
  content = each.value.record
  ttl     = 60
  type    = each.value.type
  zone_id = var.cloudflare_zone_id
  proxied = false
}




resource "aws_acm_certificate_validation" "it-tools" {
  certificate_arn         = aws_acm_certificate.it-tools.arn
  validation_record_fqdns = [for record in cloudflare_dns_record.it-tools : record.name]
}