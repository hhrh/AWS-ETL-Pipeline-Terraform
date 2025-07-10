output "lambda_function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.alphavantage_fetcher.function_name
}

output "lambda_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.alphavantage_fetcher.arn
}

output "lambda_invoke_arn" {
  description = "The Invoke ARN of the Lambda function"
  value       = aws_lambda_function.alphavantage_fetcher.invoke_arn
}

output "lambda_role_arn" {
  description = "IAM role ARN for the Lambda function"
  value       = var.lambda_role_arn
}