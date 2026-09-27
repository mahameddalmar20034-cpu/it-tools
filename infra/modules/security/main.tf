resource "aws_security_group" "alb" {
  name        = "it-tools-alb-sg"
  description = "Allow HTTP and HTTPS from the internet"
  vpc_id      = var.vpc_id

  tags = {
    Name = "it-tools-alb-sg"
  }
}


resource "aws_vpc_security_group_ingress_rule" "https-alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}



resource "aws_vpc_security_group_ingress_rule" "http-alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}




resource "aws_vpc_security_group_egress_rule" "alb" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_security_group" "task" {
  name        = "it-tools-task-sg"
  description = "Allow HTTP from the ALB to the container"
  vpc_id      = var.vpc_id

  tags = {
    Name = "it-tools-task-sg"
  }
}



resource "aws_vpc_security_group_ingress_rule" "http-task" {
  security_group_id            = aws_security_group.task.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}



resource "aws_vpc_security_group_egress_rule" "task" {
  security_group_id = aws_security_group.task.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

