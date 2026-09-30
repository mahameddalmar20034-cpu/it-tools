variable "alb_sg_id" {
  description = "ID of the ALB security group"
  type        = string
}


variable "public_subnet_ids" {
  description = "IDs of the public subnets to the ALB spans"
  type        = list(string)
}


variable "vpc_id" {
  description = "ID of the VPC where the ALB is deployed"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate for the ALB listener"
  type        = string

}


