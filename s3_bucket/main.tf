provider "aws" {
	region = var.s3_region
}

resource "random_string" "random" {
  length  = 12
  upper   = false
  numeric  = false
  lower   = true
  special = false
}

resource "aws_s3_bucket" "b" {
	bucket = "${var.s3_bucket_name}-${random_string.random.result}"
	force_destroy = true
}
# Set private bucket and versioning enabled
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.b.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.b.id
  versioning_configuration {
    status = "Enabled"
  }
}
