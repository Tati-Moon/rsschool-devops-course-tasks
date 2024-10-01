terraform {
  backend "s3" {
    bucket         = "tati.terraform-state-s3-bucket"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}