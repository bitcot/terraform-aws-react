# Create CodeBuild resource

resource "aws_codebuild_project" "build" {
  name          = "${var.stack}-${var.environment}-${var.application}-codebuild"
  description   = "${var.stack}-${var.environment}-${var.application}-codebuild"
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.codebuild.arn


  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "stack"
      value = var.stack
    }

    environment_variable {
      name  = "environment"
      value = var.environment
    }
    environment_variable {
      name  = "application"
      value = var.application
    }
    environment_variable {
      name  = "bucket_name"
      value = "${var.stack}-${var.environment}-${var.application}"
    }
    environment_variable {
      name  = "dist_id"
      value = aws_cloudfront_distribution.cdn.id
    }

  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/${var.stack}/${var.environment}/${var.application}/codebuild"
      stream_name = "codebuild"
    }

    s3_logs {
      status = "DISABLED"
    }
  }

  source {
    type = "CODEPIPELINE"
  }

  # vpc_config {
  #   vpc_id             = aws_default_vpc.default_vpc.id
  #   subnets            = [aws_default_subnet.default_subnet_a.id]
  #   security_group_ids = [module.security-group-codebuild.this_security_group_id]
  # }

}
