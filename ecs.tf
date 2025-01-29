resource "aws_ecs_cluster" "main" {
  name = "main-ecs-cluster"

  tags = {
    Name = "main-ecs-cluster"
  }
}

resource "aws_ecs_cluster_capacity_providers" "usuarios" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 1
    capacity_provider = "FARGATE"
  }
}


resource "aws_ecs_task_definition" "usuarios_task_definition" {
  family                   = "${var.micro_usuarios.name}-task-family"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.micro_usuarios.cpu
  memory                   = var.micro_usuarios.memory
  task_role_arn            = aws_iam_role.task_role_arn.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.micro_usuarios.name}-container",
      "image": "${aws_ecr_repository.usuarios.repository_url}:latest",
      "cpu": ${var.micro_usuarios.cpu},
      "memory": ${var.micro_usuarios.memory},
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${var.micro_usuarios.task_containerPort},
          "hostPort": ${var.micro_usuarios.task_hostPort},
          "protocol": "${var.micro_usuarios.task_protocol}"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/usuarios-service",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ]
  DEFINITION
}

resource "aws_ecs_service" "uasurios-service" {
  name            = "${var.micro_usuarios.name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.usuarios_task_definition.arn
  desired_count   = 1

  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
    container_name   = "${var.micro_usuarios.name}-container"
    container_port   = 80
  }

  network_configuration {
    subnets          = [aws_subnet.public.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
}

resource "aws_security_group" "ecs_sg" {
  name   = "ecs-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Solo permite tráfico desde el ALB
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}