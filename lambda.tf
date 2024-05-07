# Create Lambda Function
resource "aws_lambda_function" "sqs_poller" {
  function_name    = var.lambda_function_name
  runtime          = var.lambda_function_runtime
  handler          = "lambda_function.lambda_handler"
  filename         = var.lambda_function_filename
  role             = aws_iam_role.lambda_exec.arn
  timeout          = 30
  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.notification_topic.arn
    }
  }

}

# Link Lambda Function with SQS Queue
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  event_source_arn = aws_sqs_queue.event_queue.arn
  function_name    = aws_lambda_function.sqs_poller.arn
  enabled          = true
}

resource "aws_lambda_function_event_invoke_config" "event_invoke_config" {
  function_name = aws_lambda_function.sqs_poller.function_name

  destination_config {
    on_failure {
      destination = aws_sns_topic.notification_topic.arn
    }

    on_success {
      destination = aws_sns_topic.notification_topic.arn
    }
  }
}