{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Only keep untagged images for ${DaysToRetainUntaggedContainerImages} days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": ${DaysToRetainUntaggedContainerImages}
            },
            "action": {
                "type": "expire"
            }
        },
        {
            "rulePriority": 2,
            "description": "Keep only ${MaxTaggedContainerImagesToRetain} tagged images, expire all others",
            "selection": {
                "tagStatus": "tagged",
                "tagPrefixList": [ "latest" ],
                "countType": "imageCountMoreThan",
                "countNumber": ${MaxTaggedContainerImagesToRetain}
            },
            "action": {
                "type": "expire"
            }
        }      
    ]
}