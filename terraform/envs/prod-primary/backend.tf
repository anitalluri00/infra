terraform {
  backend "s3" {
<<<<<<< HEAD
    # Replace values before deployment.
    bucket         = "mis-terraform-state"
    key            = "prod-primary/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "mis-terraform-locks"
    encrypt        = true
=======
    # Supply bucket and region at init time:
    # terraform init -backend-config="bucket=<state-bucket>" -backend-config="region=<region>"
    key            = "prod-primary/terraform.tfstate"
    encrypt        = true
    use_lockfile   = true
>>>>>>> 6f3b0ea (Local changes before pull)
  }
}
