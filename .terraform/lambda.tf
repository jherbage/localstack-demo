
resource "aws_lambda_function" "my_function" {
  function_name = "my_function"
  description   = "Simple lambda"
  memory_size   = 128
  timeout       = 20
  handler       = "bootstrap"
  runtime       = "provided.al2"

  role = aws_iam_role.lambda_execution_role.arn

  s3_bucket = aws_s3_bucket.temp.bucket 
  s3_key    = "lambda.zip"
  
  depends_on = [
    aws_s3_object.lambda_zip
  ]         
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_policy"
  role   = aws_iam_role.lambda_execution_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
