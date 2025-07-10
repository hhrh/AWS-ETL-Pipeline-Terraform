variable "project" {
  description = "The name of the project"
  type        = string
}

variable "env" {
  description = "The deployment environment (e.g. dev, prod)"
  type        = string
}

variable "bucket_name" {
  type = string
}

variable "lambda_arn" {
  description = "The ARN of the Lambda function"
  type = string
}

variable "failure_topic_arn" {
  description = "The ARN of the SNS failure topic"
  type = string
}

variable "glue_job_arn" {
  description = "ARN of the AWS Glue Job"
  type = string
}

variable "crawler_arn" {
    description = "ARN of the AWS Glue Crawler"
    type = string
}

variable "step_function_arn" {
    description = "ARN of the EventBridge Scheduler"
    type = string
}