terraform {
  required_version = ">= 1.5.7"

  backend "s3" {
    bucket  = "aws-api-demo-tfstate"
    key     = "terraform.tfstate"
    encrypt = "true"
    region  = "us-east-2"
    profile = "terraform-demo-prod"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  profile = "terraform-demo-prod"
  region = "us-east-2"
  # Optional to limit to relevant AWS accounts. Ideally restricted by IAM credentials by terraform user
  # allowed_account_ids can help to guard the accounts if the credentials allow to assume role on another account
  # allowed_account_ids = ["1234567"]

  # Any useful tags to track resource usage
  default_tags {
    tags = {
      Environment = "prod"
      team = "MyAwesomeTeam"
      app_id = "MyAwesomeApp"
    }
  }
}
