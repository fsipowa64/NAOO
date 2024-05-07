terraform {
  backend "s3" {
    bucket = "godlist"
    key    = "terraform"
    region = "us-east-1"
  }
}