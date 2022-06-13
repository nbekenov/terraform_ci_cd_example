resource "aws_kms_key" "kms_key" {
  description             = "Key to be used by CodeBuild to encrypt data"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

resource "aws_kms_alias" "kms_key_alias" {
  name          = "alias/${local.resource_prefix}-key"
  target_key_id = aws_kms_key.kms_key.key_id
}