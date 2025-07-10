output "glue_job_name" {
  description = "Name of the AWS Glue Job"
  value       = aws_glue_job.etl_job.name
}

output "glue_job_arn" {
  description = "ARN of the AWS Glue Job"
  value       = aws_glue_job.etl_job.arn
}