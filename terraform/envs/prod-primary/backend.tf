terraform {
  backend "s3" {
    # Replace values before deployment.
    bucket         = "mis-terraform-state"
    key            = "prod-primary/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "mis-terraform-locks"
    encrypt        = true
  }
}
