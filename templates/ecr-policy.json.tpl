{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Allow Pull Image",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${prod_account_id}:root",
                    "arn:aws:iam::${test_account_id}:root"
                ]
            },
            "Action": [
                "ecr:GetAuthorizationToken",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:DescribeRepositories",
                "ecr:DescribeImages"
            ]
        }
    ]
}