resource "aws_s3_bucket" "codepipeline" {
bucket = "${var.stack}-${var.environment}-${var.application}-codepipeline"
server_side_encryption_configuration {
rule {
apply_server_side_encryption_by_default {
kms_master_key_id = aws_kms_key.kms-key.arn
sse_algorithm     = "aws:kms"
}
}
}

versioning {
enabled = true
}

lifecycle_rule {
enabled = true

noncurrent_version_transition {
days          = 60
storage_class = "STANDARD_IA"
}

noncurrent_version_expiration {
days = 90
}
}

}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.stack}-${var.environment}-${var.application}-codepipeline"
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.codepipeline.bucket
    type     = "S3"

    encryption_key {
      id   = aws_kms_alias.kms-alias.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["SourceArtifact"]
      configuration = {
        S3Bucket = "${var.stack}-${var.environment}-${var.application}-code"
        S3ObjectKey = "${var.codeprefix}"  # username/reponame/branchname/username_reponame.zip 
        PollForSourceChanges = "${var.poll-source-changes}"
      }
    }

    }

    stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]

      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }
  }


  }