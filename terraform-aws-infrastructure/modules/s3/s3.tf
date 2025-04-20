resource "aws_s3_bucket" "terraform_state" {
  bucket = var.s3_bucket_name
  lifecycle {
    # prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}
