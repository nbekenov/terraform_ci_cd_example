
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


resource "aws_codebuild_project" "codebuild_deployment" {
  name           = "${local.resource_prefix}-CodeBuildProject"
  description    = "Code build project for ${var.project_name}"
  build_timeout  = "10"
  service_role   = aws_iam_role.codebuild_role.arn
  encryption_key = aws_kms_key.kms_key.key_id

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE"]
  }

  environment {
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.cb_priviledged_mode
    compute_type                = var.codebuild_node_size

    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.container_repository.name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name = "/aws/codebuild/${var.project_name}"
    }

  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

}


resource "aws_codestarconnections_connection" "bitbucket" {
  name          = "bitbucket-connection"
  provider_type = "Bitbucket"
}

resource "aws_codepipeline" "example" {
  name     = "${local.resource_prefix}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.artifact_bucket.bucket
    type     = "S3"

    encryption_key {
      id   = aws_kms_key.kms_key.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.bitbucket.arn
        FullRepositoryId = var.bitbucket_repo_full_name
        BranchName       = var.repo_branch_name
      }
    }
  }
  stage {
    name = "Build"

    action {
      name             = "Build-${aws_codebuild_project.codebuild_deployment.name}"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 1
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = aws_codebuild_project.codebuild_deployment.name
      }
    }
  }
}