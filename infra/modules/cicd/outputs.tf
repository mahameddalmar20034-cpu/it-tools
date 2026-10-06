output "role_arn" {
  description = "ARN of the IAM role for Github actions"
  value       = aws_iam_role.github_actions.arn
}