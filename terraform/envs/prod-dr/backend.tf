terraform {
  backend "s3" {
<<<<<<< HEAD
    # Replace values before deployment.
    bucket         = "mis-terraform-state"
    key            = "prod-dr/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "mis-terraform-locks"
    encrypt        = true
=======
    # Supply bucket and region at init time:
    # terraform init -backend-config="bucket=<state-bucket>" -backend-config="region=<region>"
    key            = "prod-dr/terraform.tfstate"
    encrypt        = true
    use_lockfile   = true
>>>>>>> 6f3b0ea (Local changes before pull)
  }
}
