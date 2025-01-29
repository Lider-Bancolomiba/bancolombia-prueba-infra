terraform {
  backend "s3" {
    encrypt = true
    bucket  = "terraform-tfstate-versioning"
    key     = "proyecto/terraform-core.tfstate"
    region  = "us-east-1"
  }
  required_version = ">= 1.2.0"
}