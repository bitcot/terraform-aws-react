#########################
# General vars
#########################

variable "stack" {
    type = string
    description = "Enter the stack name"
    
}
variable "environment" {
    type = string
    description = "Enter the environment name" 
    
}
variable "application" {
  type = string  
 
}
variable "access_key" {
    type = string
    description = "Enter access key of AWS account"
    
}
variable "secret_key" {
    type = string
    description = "Enter secret key of AWS account"
    
}
variable "region_primary" {
    type = string
    description = "Enter the name of the region"
    
}

#########################
# frontend variables    #
#########################

variable "poll-source-changes" {
  default = "true"
  description = "Set whether the created pipeline should poll the source for change and triggers the pipeline"
}
variable "minimum_client_tls_protocol_version" {
  type        = string
  description = "CloudFront viewer certificate minimum protocol version"
  default     = "TLSv1.2_2021"
}
variable "codeprefix" {
  type = string
  
}
variable "cert_arn" {
  type = string 
}
variable "alias_domain_name_cloudfront" {
  type = string
  description = "Enter the alias name for cloudfront domain"
}
variable "build_timeout" {
  description = "CodeBuild build timeout in minutes"
  default     = "10"
}
