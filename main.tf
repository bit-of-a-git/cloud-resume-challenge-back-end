module "apigateway" {
  source             = "./apigateway"
  GET_lambda_invoke  = module.lambda.GET_lambda_invoke
  POST_lambda_invoke = module.lambda.POST_lambda_invoke
  GET_lambda_name    = module.lambda.GET_lambda_name
  POST_lambda_name   = module.lambda.POST_lambda_name
  append              = var.append
}

module "dynamodb" {
  source        = "./dynamodb"
  append         = var.append
}

module "lambda" {
  source                 = "./lambda"
  hit_counter_table_arn  = module.dynamodb.hit_counter_table_arn
  hit_counter_table_name = module.dynamodb.hit_counter_table_name
  ip_address_table_arn   = module.dynamodb.ip_address_table_arn
  ip_address_table_name  = module.dynamodb.ip_address_table_name
  append                  = var.append
}