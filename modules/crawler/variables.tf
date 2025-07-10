variable "project" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Deployment environment"
}

variable "bucket_name" {
  type        = string
  description = "S3 bucket name"
}

variable "glue_database_name" {
  type        = string
  description = "Glue database to register the table"
}

variable "glue_role_arn" {
  description = "IAM role to attach to the Glue Crawler"
  type        = string
}
