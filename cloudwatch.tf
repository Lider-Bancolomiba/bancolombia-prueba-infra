resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/usuarios-service"
  retention_in_days = 3
  tags = {
    Environment = "${var.env}"
    Project     = "${var.micro_usuarios.name}-project"
  }
}