
resource "aws_s3_bucket" "temp" {
  bucket = "temp-bucket"
  acl    = "private"
}

resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.temp.bucket
  key    = "lambda.zip"
  source = "${path.module}/zips/lambda.zip" 
  acl    = "private"
}