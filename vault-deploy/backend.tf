terraform {
  backend "s3" {
    bucket         = "terraform-state-avaneswaran"
    key            = "vault-deploy/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
