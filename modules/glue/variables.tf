variable "project" {
  description = "The name of the project"
  type        = string
}

variable "env" {
  description = "The deployment environment (e.g. dev, prod)"
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket that stores raw and processed data and the Glue script"
  type        = string
}

variable "glue_role_arn" {
  description = "IAM role to attach to the Glue job"
  type        = string
}
