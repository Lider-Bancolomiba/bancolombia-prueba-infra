resource "aws_ecr_repository" "usuarios" {
  name                 = "${var.micro_usuarios.name}-ecr-repository"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = "${var.env}"
    Project     = "${var.micro_usuarios.name}-project"
  }
}