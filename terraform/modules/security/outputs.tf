output "waf_web_acl_arn" {
  value = aws_wafv2_web_acl.edge.arn
}

output "cloudtrail_bucket_name" {
  value = aws_s3_bucket.cloudtrail.bucket
}

output "audit_kms_key_arn" {
  value = aws_kms_key.audit.arn
}
