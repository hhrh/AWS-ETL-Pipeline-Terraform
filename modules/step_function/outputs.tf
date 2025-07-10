output "state_machine_arn" {
  description = "ARN of the Step Function state machine"
  value       = aws_sfn_state_machine.etl_state_machine.arn
}