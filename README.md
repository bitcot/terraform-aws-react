# FRONTEND REACT MODULE

# This repository contains the terraform script for frontend.

# This includes, 
   1. S3 bucket for hosting
   2. Cloudfront distribution
   3. CodeX tools
   4. Default VPC
   5. Gitpull script (to pull code from repo to S3)


# To use this script as a terraform module, 

    1. Create a file named as main.tf
    2. Then add the below script,

        module "react" {
           source  = "bitcot/react/aws"
           version = "<Change version as per modules version>"
           # change the value accordingly  
           access_key                   = "<Access key of AWS account>"
           secret_key                   = "<Secret key of AWS account>"
           region_primary               = "<Region name>"
           stack                        = "<Name of application stack>"
           environment                  = "<Environment name>"
           application                  = "<Name of application>" 
           codeprefix                   = "<S3 object key codeprefix where the git pull code is stored in S3 bucket Ex: username/reponame/branchname/username_reponame.zip >"
           cert_arn                     = "<SSL ACM certificate arn for cloudfront>"
           alias_domain_name_cloudfront = "<Alias domain name for the cloudfront>" 
        }

    3. Insert the required variables values as shown above into this script.
    4. Then initialize and apply the terraform as,

            * terraform init
            * terraform plan 
            * terraform apply 

    5. To destroy the created infrastructure, 

            * terraform destroy

# To get the outputs, 
    
    1. Create a file called outputs.tf along with main.tf creation.
    2. Then add the below script there into the outputs.tf

        output "frntcloudfront_id" {
          description = "cloudfront id"
          value = module.react.frntcloudfront_id
        }
        output "frntcloudfrontURL" {
          description = "cloudfront url"
          value = module.react.frntcloudfrontURL
        }
        output "frntbucketname" {
          description = "frontend bucket name"
          value = module.react.frntbucketname
        }

