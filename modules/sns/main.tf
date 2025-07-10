resource "aws_sns_topic" "this" {
  name = var.topic_name
}

resource "aws_sns_topic_subscription" "email_subscriptions" {
  for_each = toset(var.email_subscribers)

  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = each.key
}