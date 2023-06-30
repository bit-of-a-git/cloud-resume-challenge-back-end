output "main_api_id" {
  description = "The ID of the Hit/IP API"
  value       = aws_api_gateway_rest_api.main.id
}

output "main_api_resource_id" {
  description = "The Resource ID of the Hit/IP API"
  value       = aws_api_gateway_rest_api.main.root_resource_id
}

output "main_api_dev_stage_URL" {
  description = "The URL of the dev API stage"
  value       = aws_api_gateway_stage.dev.invoke_url
}