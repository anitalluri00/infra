output "primary_bucket_name" {
  value = aws_s3_bucket.primary.bucket
}

output "primary_bucket_arn" {
  value = aws_s3_bucket.primary.arn
}

output "dr_bucket_name" {
  value = aws_s3_bucket.dr.bucket
}

output "dr_bucket_arn" {
  value = aws_s3_bucket.dr.arn
}
