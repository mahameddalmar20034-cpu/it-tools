output "alb_sg_id" {
  value       = aws_security_group.alb.id
  description = "ID of the ALB security group"
}

output "task_sg_id" {
  value       = aws_security_group.task.id
  description = "ID of the task group security group"

}