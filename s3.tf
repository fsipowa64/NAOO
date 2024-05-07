resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  queue {
    queue_arn = aws_sqs_queue.event_queue.arn
    events    = ["s3:ObjectCreated:*"]
    # filter_suffix = ".log"
  }
}