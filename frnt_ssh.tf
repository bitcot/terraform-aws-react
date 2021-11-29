resource "aws_cloudformation_stack" "cf" {
  name = "${var.stack}-${var.environment}-sshfrontend"
  parameters = {
    AllowedIps   =  "13.52.5.96/28,13.236.8.224/28,18.136.214.96/28,18.184.99.224/28,18.234.32.224/28,18.246.31.224/28,52.215.192.224/28,104.192.137.240/28,104.192.138.240/28,104.192.140.240/28,104.192.142.240/28,104.192.143.240/28,185.166.143.240/28,185.166.142.240/28",
    OutputBucketName = "${var.stack}-${var.environment}-${var.application}-code"
  }

  template_body = file("frnt_cloudformationtemplate/ssh.yml")
  capabilities  = ["CAPABILITY_NAMED_IAM","CAPABILITY_IAM"]

}