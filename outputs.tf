output "apigateway_stage_URL" {  
  value = module.apigateway.visitor_count_api_stage_URL
}

output "dynamodb_table_name" {  
  value = module.dynamodb.visitor_table_name
}