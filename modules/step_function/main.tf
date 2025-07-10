resource "aws_sfn_state_machine" "etl_state_machine" {
  name     = "${var.project}-${var.env}-etl-state-machine"
  role_arn = var.step_function_role_arn

  definition = templatefile("${path.module}/step_function_definition.json.tpl", {
    lambda_arn     = var.lambda_arn
    glue_job_name  = var.glue_job_name
    crawler_name   = var.crawler_name
    bucket_name    = var.bucket_name
    sns_topic_arn  = var.sns_topic_arn
    env            = var.env
    project        = var.project
  })
}