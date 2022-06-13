
resource "aws_s3_bucket" "artifact_bucket" {
  #checkov:skip=CKV_AWS_144: "Ensure that S3 bucket has cross-region replication enabled"
  #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"
  bucket = "${local.resource_prefix}-artifact-bucket"
}

resource "aws_s3_bucket_acl" "artifact_bucket_acl" {
  bucket = aws_s3_bucket.artifact_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "artifact_bucket_versioning" {
  bucket = aws_s3_bucket.artifact_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "pipeline_buckets" {
  bucket                  = aws_s3_bucket.artifact_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}

resource "aws_s3_bucket_server_side_encryption_configuration" "pipeline_buckets" {
  bucket = aws_s3_bucket.artifact_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}