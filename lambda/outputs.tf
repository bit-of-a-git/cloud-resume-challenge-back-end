output "GET_lambda_invoke" {
  description = "ARN of the GET Lambda"
  value       = aws_lambda_function.VisitorCount.invoke_arn
}

output "POST_lambda_invoke" {
  description = "ARN of the GET Lambda"
  value       = aws_lambda_function.VisitorUpdate.invoke_arn
}

output "GET_lambda_name" {
  description = "ARN of the GET Lambda"
  value       = aws_lambda_function.VisitorCount.function_name
}

output "POST_lambda_name" {
  description = "ARN of the GET Lambda"
  value       = aws_lambda_function.VisitorUpdate.function_name
}
