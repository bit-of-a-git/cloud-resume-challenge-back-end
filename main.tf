data "git_repository" "main" {
  path = path.root
}

module "apigateway" {
  source             = "./apigateway"
  GET_lambda_invoke  = module.lambda.GET_lambda_invoke
  POST_lambda_invoke = module.lambda.POST_lambda_invoke
  GET_lambda_name    = module.lambda.GET_lambda_name
  POST_lambda_name   = module.lambda.POST_lambda_name
  git_commit_id      = substr(data.git_repository.main.commit_sha, 0, 13)
}

module "dynamodb" {
  source        = "./dynamodb"
  git_commit_id = substr(data.git_repository.main.commit_sha, 0, 13)
}

module "lambda" {
  source                 = "./lambda"
  hit_counter_table_arn  = module.dynamodb.hit_counter_table_arn
  hit_counter_table_name = module.dynamodb.hit_counter_table_name
  ip_address_table_arn   = module.dynamodb.ip_address_table_arn
  ip_address_table_name  = module.dynamodb.ip_address_table_name
  git_commit_id          = substr(data.git_repository.main.commit_sha, 0, 13)
}