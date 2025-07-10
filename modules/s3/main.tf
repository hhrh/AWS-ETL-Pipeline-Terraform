resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "mycompany-${var.project}-${var.env}-${random_id.suffix.hex}"
}

resource "aws_s3_bucket_public_access_block" "my_bucket_block" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

locals {
  prefixes = ["raw/", "processed/", "athena-results/"]
}

resource "aws_s3_object" "folders" {
  for_each = toset(local.prefixes)

  bucket = aws_s3_bucket.my_bucket.id
  key    = each.value
}