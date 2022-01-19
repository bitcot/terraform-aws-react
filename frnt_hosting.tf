resource "aws_s3_bucket" "bucket" {
      bucket =  "${var.stack}-${var.environment}-${var.application}"
      tags = {
        Name = "${var.stack}-${var.environment}-${var.application}"
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
      server_side_encryption_configuration {
      rule {
       apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
       }
      }
    }
}
locals {
  s3_origin_id = "myS3Origin"
}



resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = aws_s3_bucket.bucket.id
}

# cloudfront
resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = "${aws_s3_bucket.bucket.bucket_regional_domain_name}"
    origin_id   = "${local.s3_origin_id}"

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${aws_cloudfront_origin_access_identity.origin_access_identity.id}"
    }
    
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "cdn"
  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.s3_origin_id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

    custom_error_response {
        error_code = 403 
        response_code = 200 
        response_page_path = "/index.html"

    }
    custom_error_response {
        error_code = 404
        response_code = 200
        response_page_path = "/index.html"

    }
    restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

### if using custom domain comment this code   
  viewer_certificate {
    acm_certificate_arn            = var.cert_arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1" 
  }
  aliases = [var.alias_domain_name_cloudfront]
  
  tags = {
    Environment = "${var.stack}-${var.environment}-${var.application}"
    createdby = "Bitcot"
  }

  # end

### if not using custom domain uncomment this code 


#   viewer_certificate {
#     cloudfront_default_certificate = true
#   }

# end

  
}


resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Principal": {
        "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.origin_access_identity.id}"
      },
      "Resource": "${aws_s3_bucket.bucket.arn}/*"
    }
  ]
}
POLICY
}
