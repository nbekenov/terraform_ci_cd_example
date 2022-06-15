
resource "aws_iam_role" "codebuild_role" {
  name = "${local.resource_prefix}-codebuild_deploy_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "${local.resource_prefix}_codebuild_deployment_policy"
  role = aws_iam_role.codebuild_role.name

  policy = templatefile("${path.module}/templates/codebuild_policy.json.tpl",
    {
      cmk_arn             = aws_kms_key.kms_key.arn
      artifact_bucket_arn = aws_s3_bucket.artifact_bucket.arn
      ecr_arn             = aws_ecr_repository.container_repository.arn
      partition           = data.aws_partition.current.partition
      region              = local.region
      account_id          = local.account_id
      project_name        = var.project_name
  })
}

#########################################################################
resource "aws_iam_role" "codepipeline_role" {
  name = "${local.resource_prefix}-codepipeline_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${local.resource_prefix}-codepipeline_policy"
  role = aws_iam_role.codepipeline_role.name

  policy = templatefile("${path.module}/templates/codepipeline_policy.json.tpl",
    {
      cmk_arn             = aws_kms_key.kms_key.arn
      artifact_bucket_arn = aws_s3_bucket.artifact_bucket.arn
      partition           = data.aws_partition.current.partition
      region              = local.region
      account_id          = local.account_id
      project_name        = var.project_name
      connection_arn      = aws_codestarconnections_connection.bitbucket.arn
  })
}