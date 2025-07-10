variable "step_function_arn" {
  description = "ARN of the Step Function to trigger"
  type        = string
}

variable "eventbridge_invoke_role_arn" {
  description = "IAM role ARN that allows EventBridge to start the Step Function"
  type        = string
}

variable "project" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Deployment environment"
}