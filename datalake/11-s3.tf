resource "aws_s3_bucket" "logs_bucket" {
  bucket        = "madetech-emr-log-bucket"
  force_destroy = true
}

resource "aws_s3_bucket" "emr_studio_bucket_mt" {
  bucket        = var.s3_emr_studio_name
  force_destroy = true
}

#resource "aws_s3_bucket_acl" "logs_bucket" {
 # bucket        = aws_s3_bucket.logs_bucket.id
 # acl           = "private"
#}
