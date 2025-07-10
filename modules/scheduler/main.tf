resource "aws_cloudwatch_event_rule" "daily_trigger" {
  name                = "${var.project}-${var.env}-daily-trigger"
  description         = "Triggers Step Function every day at 6 AM UTC"
  schedule_expression = "cron(0 6 * * ? *)"
}

resource "aws_cloudwatch_event_target" "trigger_step_function" {
  rule      = aws_cloudwatch_event_rule.daily_trigger.name
  target_id = "StepFunctionTarget"
  arn       = var.step_function_arn

  role_arn = var.eventbridge_invoke_role_arn
}