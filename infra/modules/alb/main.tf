resource "aws_lb" "it-tools" {
  name               = "it-tools-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false



  tags = {
    Name = "it-tools-alb"
  }
}

resource "aws_lb_target_group" "it-tools" {
  name        = "it-tools-alb-tg"
  target_type = "ip"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  health_check {
    path = "/"
  }

}








resource "aws_lb_listener" "https-it-tools" {
  load_balancer_arn = aws_lb.it-tools.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.it-tools.arn
  }
}



resource "aws_lb_listener" "http-it-tools" {
  load_balancer_arn = aws_lb.it-tools.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}





