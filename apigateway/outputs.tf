output "visitor_count_api_id" {
  description = "The ID of the Visitor Count API"
  value       = aws_api_gateway_rest_api.visitor_count.id
}

output "visitor_count_api_resource_id" {
  description = "The Resource ID of the Visitor Count API"
  value       = aws_api_gateway_rest_api.visitor_count.root_resource_id
}

output "visitor_count_api_stage_URL" {
  description = "The URL of the API stage"
  value       = aws_api_gateway_stage.dev.invoke_url
}