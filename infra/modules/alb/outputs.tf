output "alb_dns_name" {
  value       = aws_lb.it-tools.dns_name
  description = "DNS name of the ALB "
}

output "target_group_arn" {
  value       = aws_lb_target_group.it-tools.arn
  description = "ARN of the target group"
}
