variable "repository_url" {
    type = string
    description = "The URL for the ECR repository"
}

variable "public_subnet_ids" {
    type = list(string)
    description = "IDs of public subnets for the task"
}


variable "task_sg_id" {
    type = string
    description = "IDs of security group  attached to the ECS task"
}

variable "target_group_arn" {
    type = string
    description = "The ARN of the target group for the ECS service"

}