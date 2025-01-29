env = "prod"
micro_usuarios = {
  name               = "usuarios"
  cpu                = 256
  memory             = 512
  task_containerPort = 80
  task_hostPort      = 80
  task_protocol      = "tcp"
  app_image          = "235494800782.dkr.ecr.us-east-1.amazonaws.com/usuarios-ecr-repository:latest"
}