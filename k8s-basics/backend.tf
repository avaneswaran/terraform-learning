terraform {
  backend "s3" {
    bucket         = "terraform-state-avaneswaran"
    key            = "k8s-basics/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
