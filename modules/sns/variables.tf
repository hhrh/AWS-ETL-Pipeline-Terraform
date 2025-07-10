variable "topic_name" {
  description = "Name of the SNS topic"
  type        = string
}

variable "email_subscribers" {
  description = "List of email addresses to subscribe"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to the SNS topic"
  type        = map(string)
  default     = {}
}