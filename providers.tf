terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    git = {
      source  = "innovationnorway/git"
      version = "0.1.3"
    }
  }

  backend "s3" {
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-lock-back-end"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "git" {
}