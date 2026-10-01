output "certificate_arn" {
  value       = aws_acm_certificate_validation.it-tools.certificate_arn
  description = "The ARN of the validated ACM certificate for it-tools"

}
