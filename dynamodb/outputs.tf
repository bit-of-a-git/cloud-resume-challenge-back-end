output "hit_counter_table_arn" {
  description = "ARN of the hit counter table"
  value       = aws_dynamodb_table.hit_counter.arn
}

output "hit_counter_table_name" {
  description = "Name of the hit counter table"
  value       = aws_dynamodb_table.hit_counter.id
}

output "ip_address_table_arn" {
  description = "ARN of the visitor count table"
  value       = aws_dynamodb_table.ip_address.arn
}

output "ip_address_table_name" {
  description = "Name of the visitor count table"
  value       = aws_dynamodb_table.ip_address.id
}