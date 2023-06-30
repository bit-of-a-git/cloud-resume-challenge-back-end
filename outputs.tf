output "apigateway_stage_URL" {
  value = module.apigateway.main_api_dev_stage_URL
}

output "dynamodb_table_name" {
  value = module.dynamodb.ip_address_table_name
}