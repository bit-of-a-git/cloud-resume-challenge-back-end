output "visitor_count_api_id" {
  description = "The ID of the Visitor Count API"
  value       = aws_api_gateway_rest_api.visitor_count.id
}

output "visitor_count_api_resource_id" {
  description = "The Resource ID of the Visitor Count API"
  value       = aws_api_gateway_rest_api.visitor_count.root_resource_id
}