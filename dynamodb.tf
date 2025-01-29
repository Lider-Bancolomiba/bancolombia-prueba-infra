resource "aws_dynamodb_table" "users_table" {
  name         = "${var.micro_usuarios.name}-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "user_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  tags = {
    Environment = "${var.env}"
    Project     = "${var.micro_usuarios.name}-project"
  }
}