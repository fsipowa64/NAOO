# Create SNS Topic
resource "aws_sns_topic" "notification_topic" {
  name = var.sns_topic_name
}

# Subscribe email Function to SNS Topic
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.notification_topic.arn
  protocol  = var.sns_protocol
  endpoint  = var.sns_topic_email
}