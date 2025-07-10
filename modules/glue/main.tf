# Upload the Glue script to S3
resource "aws_s3_object" "glue_script" {
  bucket = var.bucket_name
  key    = "scripts/glue_job.py"
  source = "${path.module}/../../scripts/glue_job.py"
  etag   = filemd5("${path.module}/../../scripts/glue_job.py")
  content_type = "text/x-python"
}

# Create the Glue Job
resource "aws_glue_job" "etl_job" {
  name     = "${var.project}-${var.env}-glue-job"
  role_arn = var.glue_role_arn

  command {
    name            = "glueetl"
    script_location = "s3://${var.bucket_name}/scripts/glue_job.py"
    python_version  = "3"
  }

  glue_version     = "5.0"
  number_of_workers = 2
  worker_type       = "G.1X"
  execution_class   = "FLEX"
  max_retries       = 0
  timeout           = 10 # minutes

  default_arguments = {
    "--job-language"      = "python"
    "--JOB_NAME"          = "${var.project}-${var.env}-glue-job"
    "--input_path"        = "s3://${var.bucket_name}/raw/"
    "--output_path"       = "s3://${var.bucket_name}/processed/"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-metrics"    = "true"
    "--enable-glue-datacatalog" = "true"
  }

  depends_on = [aws_s3_object.glue_script]
}