{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject*",
        "s3:GetBucket*",
        "s3:GetBucketPolicy",
        "s3:GetBucketLocation",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:List*",
        "s3:Abort*"
      ],
      "Resource": [
        "${artifact_bucket_arn}",
        "${artifact_bucket_arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:DescribeKey",
        "kms:GenerateDataKey*",
        "kms:Encrypt",
        "kms:ReEncrypt*",
        "kms:Decrypt"
      ],
      "Resource": "${cmk_arn}"
    },
    {
      "Effect": "Allow",
      "Action": "ecr:GetAuthorizationToken",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
        "codebuild:StopBuild",
        "codebuild:CreateReportGroup"
      ],
      "Resource": "arn:${partition}:codebuild:${region}:${account_id}:*/${project_name}*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection",
        "codestar-connections:GetConnection",
        "codestar-connections:ListConnections"
      ],
      "Resource": "${connection_arn}"
    }
  ]
}