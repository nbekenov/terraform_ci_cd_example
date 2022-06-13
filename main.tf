
resource "aws_ecr_repository" "container_repository" {
  #checkov:skip=CKV_AWS_136: "Ensure that ECR repositories are encrypted using KMS"
  name                 = "${local.resource_prefix}-containers"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "AES256"
  }
}

resource "aws_ecr_repository_policy" "repository_policy" {
  repository = aws_ecr_repository.container_repository.name

  policy = templatefile("${path.module}/templates/ecr-policy.json.tpl",
    {
      prod_account_id = var.prod_account_id
      test_account_id = var.test_account_id
  })
}

resource "aws_ecr_lifecycle_policy" "repository_lifecycle_policy" {
  repository = aws_ecr_repository.container_repository.name

  policy = templatefile("${path.module}/templates/ecr-lifecycle-policy.json.tpl",
    {
      DaysToRetainUntaggedContainerImages = 7
      MaxTaggedContainerImagesToRetain    = 2
  })

}

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

# rCodeBuildProject

# rPipeline