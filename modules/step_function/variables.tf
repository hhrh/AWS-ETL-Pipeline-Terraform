variable "project" {
  description = "Project name"
  type        = string
}

variable "env" {
  description = "Environment (e.g., dev, prod)"
  type        = string
}

variable "lambda_arn" {
  description = "ARN of the Lambda function to invoke"
  type        = string
}

variable "glue_job_name" {
  description = "Name of the AWS Glue Job"
  type        = string
}

variable "crawler_name" {
  description = "Name of the AWS Glue Crawler"
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name used for input and output"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS Topic ARN for failure notifications"
  type        = string
}

variable "step_function_role_arn" {
  description = "IAM Role ARN for the Step Function execution"
  type        = string
}