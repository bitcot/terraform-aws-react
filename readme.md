#################### FRONTEND REACT MODULE #######################

# This repository contains the terraform script for frontend.

# This includes, 
   1. S3 bucket for hosting
   2. Cloudfront distribution
   3. CodeX tools
   4. Default VPC
   5. Gitpull script (to pull code from repo to S3)


# To use this script without using as a module, 

    1. Clone the repository to your local machine.
    2. Add the values for the variables in variables.tf file
    3. The input variables needed to enter are,
     
          * access_key                   - Access key of AWS account
          * secret_key                   - Secret key of AWS account
          * region_primary               - Region name
          * stack                        - Name of application stack
          * environment                  - Environment name
          * application                  - Name of application 
          * codeprefix                   - S3ObjectKey path where code is stored
          * cert_arn                     - SSL ACM certificate arn
          * alias_domain_name_cloudfront - Alias domain name for the cloudfront
        
    4. After including the variables, enter
            
          * terraform init
          * terraform plan
          * terraform apply 

# To use this script as a terraform module, 

    1. Create a file named as main.tf
    2. Then add the below script,

        module "react" {
           source  = "bitcot/react/aws"
           version = "1.0.1"
           # insert the 9 required variables here  
            
        }

    3. Insert the required variables values as shown above into this script.
    4. Then initialize and apply the terraform as,

            * terraform init
            * terraform plan 
            * terraform apply 
