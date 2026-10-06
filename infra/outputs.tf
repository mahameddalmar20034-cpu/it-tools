output "alb_dns_name" {
  description = "The dns name of the ALB"
  value       = module.alb.alb_dns_name
}

output "repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}



output "github_actions_role_arn" {
  description = "ARN of the IAM role that Github actions assumes"
  value       = module.cicd.role_arn
}