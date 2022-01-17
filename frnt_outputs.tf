output "frntcloudfront_id" {
  description = "cloudfront id"
  value = aws_cloudfront_distribution.cdn.id
}
output "frntcloudfrontURL" {
  value = aws_cloudfront_distribution.cdn.domain_name
}
output "frntbucketname" {
  value = aws_s3_bucket.bucket.id
}
output "codepipelinename" {
  value = aws_codepipeline.codepipeline.name
}



