terraform {
  backend "s3" {
    # Replace values before deployment.
    bucket         = "mis-terraform-state"
    key            = "prod-dr/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "mis-terraform-locks"
    encrypt        = true
  }
}
