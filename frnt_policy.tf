
data "aws_caller_identity" "current" {}

#  CodePipeline role and policy

data "template_file" "codepipeline-policy" {
template = file("${path.module}/codepipeline-policy.json.tpl")

vars = {
account_id  = data.aws_caller_identity.current.account_id
region      = var.region_primary
stack       = var.stack
environment = var.environment
application   = var.application
}
}

resource "aws_iam_policy" "codepipeline" {
name        = "${var.stack}-${var.environment}-${var.application}-codepipeline-policy"
description = "${var.stack}-${var.environment}-${var.application}-codepipeline-policy"
policy      = data.template_file.codepipeline-policy.rendered
}

resource "aws_iam_role" "codepipeline" {
name        = "${var.stack}-${var.environment}-${var.application}-codepipeline"
description = "${var.stack}-${var.environment}-${var.application}-codepipeline"


assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
  	  "Action": "sts:AssumeRole",
  	  "Principal": {
  		"Service": "codepipeline.amazonaws.com"
  	  },
  	  "Effect": "Allow",
  	  "Sid": ""
  	}
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "codepipeline" {
name       = aws_iam_policy.codepipeline.name
roles      = [aws_iam_role.codepipeline.name]
policy_arn = aws_iam_policy.codepipeline.arn
}


resource "aws_kms_key" "kms-key" {
description         = "${var.stack} ${var.environment} ${var.application} KMS Key"
enable_key_rotation = "true"

policy = <<POLICY
{
    "Version": "2012-10-17",
    "Id": "KMSPolicy",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "codestar-notifications.amazonaws.com"
            },
            "Action": [
                "kms:GenerateDataKey*",
                "kms:Decrypt"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "sns.${var.region_primary}.amazonaws.com"
                }
            }
        }
    ]
}
POLICY

}

resource "aws_kms_alias" "kms-alias" {
name          = "alias/${var.stack}-${var.environment}-${var.application}-kms-key-account"
target_key_id = aws_kms_key.kms-key.key_id
}



# CodeBuild role and policy

data "template_file" "codebuild-policy" {
template = file("${path.module}/codebuild-policy.json.tpl")

vars = {
kms_key_id  = aws_kms_key.kms-key.arn
account_id  = data.aws_caller_identity.current.account_id
region      = var.region_primary
stack       = var.stack
environment = var.environment
application   = var.application
}
}

resource "aws_iam_policy" "codebuild" {
name        = "${var.stack}-${var.environment}-${var.application}-codebuild-policy"
description = "${var.stack}-${var.environment}-${var.application}-codebuild-policy"
policy      = data.template_file.codebuild-policy.rendered
}

resource "aws_iam_role" "codebuild" {
name        = "${var.stack}-${var.environment}-${var.application}-codebuild"
description = "${var.stack}-${var.environment}-${var.application}-codebuild"

assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
  	  "Action": "sts:AssumeRole",
  	  "Principal": {
  		"Service": "codebuild.amazonaws.com"
  	  },
  	  "Effect": "Allow",
  	  "Sid": ""
  	}
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "codebuild" {
name       = aws_iam_policy.codebuild.name
roles      = [aws_iam_role.codebuild.name]
policy_arn = aws_iam_policy.codebuild.arn
}

## END: Configure IAM roles, policies, instance profiles

# # code build sg
# module "security-group-codebuild" {
# source  = "terraform-aws-modules/security-group/aws"
# version = "3.1.0"

# name         = "${var.stack}-${var.environment}-${var.application}-codebuild-sg"
# description  = "${var.stack}-${var.environment}-${var.application}-codebuild-sg"
# vpc_id       = aws_default_vpc.default_vpc.id
# egress_rules = ["all-all"]
# }


