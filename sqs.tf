# Create SQS Queue
resource "aws_sqs_queue" "event_queue" {
  name = var.sqs_queue_name
}

resource "aws_sqs_queue_policy" "queue_policy" {
  queue_url = aws_sqs_queue.event_queue.id
  policy    = data.aws_iam_policy_document.queue.json
}