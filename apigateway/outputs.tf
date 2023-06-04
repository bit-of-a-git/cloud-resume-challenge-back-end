output "Records_api_id" {
  description = "Records API ID"
  value       = aws_api_gateway_rest_api.Records.id
}

output "Records_api_resource_id" {
  description = "Records API Resource ID"
  value       = aws_api_gateway_rest_api.Records.root_resource_id
}