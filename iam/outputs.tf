output "glue_role_arn" {
  description = "ARN of the Glue IAM role"
  value       = aws_iam_role.glue_role.arn
}

output "lambda_role_arn" {
  description = "ARN of the Lambda IAM role"
  value       = aws_iam_role.lambda_exec.arn
}

output "step_function_role_arn" {
    description = "ARN of the Step Function IAM role"
    value       = aws_iam_role.step_function_role.arn
}

output "eventbridge_invoke_role_arn" {
    description = "ARN of the eventbridge IAM role"
    value       = aws_iam_role.eventbridge_invoke_role.arn
}