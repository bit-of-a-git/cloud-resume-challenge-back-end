terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region                   = "eu-west-1"
  shared_credentials_files = ["~/.aws/credentials"]
  shared_config_files      = ["~/.aws/config"]
}

module "lambda" {
  source            = "./lambda"
  visitor_table_arn = module.dynamodb.visitor_table_arn
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

module "api-gateway-enable-cors" {
  source          = "squidfunk/api-gateway-enable-cors/aws"
  version         = "0.3.3"
  api_id          = module.apigateway.Records_api_id
  api_resource_id = module.apigateway.Records_api_resource_id
}