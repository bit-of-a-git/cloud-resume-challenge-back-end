output "GET_lambda_name" {
  description = "ARN of the GET Lambda"
  value       = aws_lambda_function.GET.function_name
}

output "GET_lambda_invoke" {
  description = "ARN of the GET Lambda"
  value       = aws_lambda_function.GET.invoke_arn
}

output "POST_lambda_name" {
  description = "ARN of the GET Lambda"
  value       = aws_lambda_function.POST.function_name
}

output "POST_lambda_invoke" {
  description = "ARN of the GET Lambda"
  value       = aws_lambda_function.POST.invoke_arn
}