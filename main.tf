provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      Project     = var.project
      Environment = var.env
      Owner       = "data-team"
    }
  }
}

module "iam" {
  source            = "./iam"
  project           = var.project
  env               = var.env
  bucket_name       = module.s3.bucket_name
  lambda_arn        = module.lambda.lambda_arn
  glue_job_arn      = module.glue.glue_job_arn
  crawler_arn       = module.crawler.crawler_arn
  failure_topic_arn = module.sns.topic_arn
  step_function_arn = module.step_function.state_machine_arn
}

module "s3" {
  source  = "./modules/s3"
  project = var.project
  env     = var.env
}

module "lambda" {
  source          = "./modules/lambda"
  bucket_name     = module.s3.bucket_name
  project         = var.project
  env             = var.env
  api_key         = var.alphavantage_api_key
  stock_symbol    = var.stock_symbol
  lambda_role_arn = module.iam.lambda_role_arn
}

module "glue" {
  source        = "./modules/glue"
  project       = var.project
  env           = var.env
  bucket_name   = module.s3.bucket_name
  glue_role_arn = module.iam.glue_role_arn
}

module "crawler" {
  source             = "./modules/crawler"
  project            = var.project
  env                = var.env
  bucket_name        = module.s3.bucket_name
  glue_role_arn      = module.iam.glue_role_arn
  glue_database_name = "stock_data"
}

module "sns" {
  source            = "./modules/sns"
  topic_name        = "${var.project}-${var.env}-etl-failures"
  email_subscribers = ["hardy.git@gmail.com"]
}

module "step_function" {
  source = "./modules/step_function"

  project                = var.project
  env                    = var.env
  lambda_arn             = module.lambda.lambda_arn
  glue_job_name          = module.glue.glue_job_name
  crawler_name           = module.crawler.crawler_name
  bucket_name            = module.s3.bucket_name
  sns_topic_arn          = module.sns.topic_arn
  step_function_role_arn = module.iam.step_function_role_arn

  depends_on = [
    module.lambda,
    module.glue,
    module.crawler,
    module.sns
  ]
}

module "scheduler" {
  source = "./modules/scheduler"

  project                     = var.project
  env                         = var.env
  step_function_arn           = module.step_function.state_machine_arn
  eventbridge_invoke_role_arn = module.iam.eventbridge_invoke_role_arn
}