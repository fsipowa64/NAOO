variable "region" {
  type = string
}
variable "iam_role_name" {
  type = string
}
variable "lambda_function_name" {
  type = string
}
variable "lambda_function_runtime" {
  type = string
}
variable "lambda_function_filename" {
  type = string
}
variable "bucket_name" {
  type = string
}
variable "sns_topic_name" {
  type = string
}
variable "sns_protocol" {
  type = string
}
variable "sns_topic_email" {
  type = string
}
variable "sqs_queue_name" {
  type = string
}