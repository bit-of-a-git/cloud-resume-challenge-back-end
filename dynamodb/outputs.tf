output "visitor_table_arn" {
  description = "ARN of the visitor count table"
  value       = aws_dynamodb_table.visitor.arn
}

output "visitor_table_name" {
  description = "Name of the visitor count table"
  value       = aws_dynamodb_table.visitor.id
}