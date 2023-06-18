terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-back-end-state"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform-lock-back-end"
    encrypt        = true
  }
}

provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source            = "./lambda"
  visitor_table_arn = module.dynamodb.visitor_table_arn
  visitor_table_name = module.dynamodb.visitor_table_name
}

module "dynamodb" {
  source = "./dynamodb"
}

module "apigateway" {
  source             = "./apigateway"
  GET_lambda_invoke  = module.lambda.GET_lambda_invoke
  POST_lambda_invoke = module.lambda.POST_lambda_invoke
  GET_lambda_name    = module.lambda.GET_lambda_name
  POST_lambda_name   = module.lambda.POST_lambda_name
}