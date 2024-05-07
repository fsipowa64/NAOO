resource "aws_iam_policy" "s3_sqs" {
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqss3id",
  "Statement": [
    {
      "Sid": "sqss3",
      "Effect": "Allow",
      "Action": [
        "SQS:*"
      ],
      "Resource": "${aws_sqs_queue.event_queue.arn}",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "${aws_s3_bucket.bucket.arn}" 
        },
        "StringEquals": {
          "aws:SourceAccount": "400143264072"
        }
      }
    }
  ]
}
POLICY
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_exec" {
  name = var.iam_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
  # Attach policies
  inline_policy {
    name = "lambda_sqs_policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [{
        Effect   = "Allow",
        Action   = "sqs:*",
        Resource = aws_sqs_queue.event_queue.arn
      }]
    })
  }
  inline_policy {
    name = "AWSLambdaBasicExecutionRole"
    policy = jsonencode(
      {
        "Version" : "2012-10-17",
        "Statement" : [
          {
            "Effect" : "Allow",
            "Action" : [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource" : "*"
          }
        ]
      }
    )
  }
  inline_policy {
    name = "AmazonSNSAccess"
    policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "sns:*"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ]
      }
    )
  }
  inline_policy {
    name = "lambda_s3_policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [{
        Effect = "Allow",
        Action = [
          "s3:*"
        ],
        Resource = [
          "${aws_s3_bucket.bucket.arn}",
          "${aws_s3_bucket.bucket.arn}/*"
        ]
      }]
    })
  }
}

data "aws_iam_policy_document" "queue" {
  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["sqs:SendMessage"]
    resources = ["${aws_sqs_queue.event_queue.arn}"]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = ["${aws_s3_bucket.bucket.arn}"]
    }
  }
}


resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.s3_sqs.arn
}