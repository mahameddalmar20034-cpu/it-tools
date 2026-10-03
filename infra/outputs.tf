output "alb_dns_name" {
  description = "The dns name of the ALB"
  value       = module.alb.alb_dns_name
}

output "repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}



