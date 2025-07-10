# S3 outputs
output "bucket_name" {
  value = module.s3.bucket_name
}

# Lambda outputs
output "lambda_arn" {
  description = "ARN of the AWS Lambda function"
  value       = module.lambda.lambda_arn
}

output "lambda_invoke_arn" {
  description = "Invoke ARN of the AWS Lambda function"
  value       = module.lambda.lambda_invoke_arn
}

# Glue outputs
output "glue_job_name" {
  description = "Name of the AWS Glue Job"
  value       = module.glue.glue_job_name
}

output "glue_job_arn" {
  description = "ARN of the AWS Glue Job"
  value       = module.glue.glue_job_arn
}

# Glue Crawler outputs
output "crawler_arn" {
  description = "ARN of the Glue Crawler"
  value       = module.crawler.crawler_arn
}

# SNS outputs
output "topic_arn" {
  description = "The ARN of the SNS topic"
  value       = module.sns.topic_arn
}

# Step Function outputs
output "state_machine_arn" {
  description = "ARN of the Step Function state machine"
  value       = module.step_function.state_machine_arn
}

# EventBridge Scheduler outputs
output "scheduler_event_rule_arn" {
  description = "CloudWatch Scheduler rule ARN"
  value       = module.scheduler.event_rule_arn
}

output "scheduler_event_target_arn" {
  description = "ARN of the Step Function triggered by CloudWatch"
  value       = module.scheduler.event_target_arn
}