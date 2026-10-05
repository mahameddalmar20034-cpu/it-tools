resource "aws_ecs_cluster" "it-tools" {
  name = "it-tools-cluster"

  
}


resource "aws_cloudwatch_log_group" "it-tools" {
  name = "ecs-log-group"

  tags = {
    Name= "ecs-log-group"
    retention_in_days = 7
    
  }
}


resource "aws_iam_role" "it-tools" {
  name = "it-tools-iam-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    name = "it-tools-iam-role"
  }
}








resource "aws_iam_role_policy_attachment" "it-tools" {
  role       = aws_iam_role.it-tools.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}



resource "aws_ecs_task_definition" "it-tools" {
  family = "it-tools-service"
  
  cpu= "256"
  memory = "512"
  requires_compatibilities = ["FARGATE"]
   network_mode             = "awsvpc"
   execution_role_arn       = aws_iam_role.it-tools.arn
  container_definitions = jsonencode([
    {
      name      = "Main"
      image     = "${var.repository_url}:latest"
      
      essential = true

      logConfiguration = {
  logDriver = "awslogs"
  options = {
    "awslogs-group"         = aws_cloudwatch_log_group.it-tools.name
    "awslogs-region"        = "eu-north-1"
    "awslogs-stream-prefix" = "ecs"
  }
}
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
    
  ])

  

}


resource "aws_ecs_service" "it-tools" {
  name            = "it-tools-service"
  cluster         = aws_ecs_cluster.it-tools.id
  task_definition = aws_ecs_task_definition.it-tools.arn
  desired_count   = 1
  launch_type = "FARGATE"

  network_configuration {
  subnets          = var.public_subnet_ids
  security_groups  = [var.task_sg_id]
  assign_public_ip = true
}

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "Main"
    container_port   = 80
  }

 
}
