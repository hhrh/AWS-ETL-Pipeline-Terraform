output "event_rule_arn" {
  description = "The ARN of the CloudWatch event rule"
  value       = aws_cloudwatch_event_rule.daily_trigger.arn
}

output "event_target_arn" {
  description = "The target ARN that the CloudWatch rule triggers (Step Function)"
  value       = aws_cloudwatch_event_target.trigger_step_function.arn
}