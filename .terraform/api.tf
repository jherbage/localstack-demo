data "aws_caller_identity" "current" {}

resource "aws_api_gateway_rest_api" "my_api" {
  name        = "myapi"
  description = "A simple API"
  tags = {
    _custom_id_ = "myid123" # hard code the ID so it doesn't need looking up
  }
}

resource "aws_api_gateway_resource" "my_api_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "myapi"
}

resource "aws_api_gateway_method" "my_api_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.my_api_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "my_api_integration" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  resource_id = aws_api_gateway_resource.my_api_resource.id
  http_method = aws_api_gateway_method.my_api_get_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/${aws_lambda_function.my_function.arn}/invocations"
}

resource "aws_api_gateway_deployment" "my_api_deployment" {
  depends_on = [
    aws_api_gateway_method.my_api_get_method,
    aws_api_gateway_integration.my_api_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.my_api.id
  description = "First Deployment"
}

resource "aws_api_gateway_stage" "my_api_stage" {
  stage_name    = "v1"
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  deployment_id = aws_api_gateway_deployment.my_api_deployment.id
  description   = "Stage for My API"
}

resource "aws_lambda_permission" "my_api_lambda_permission" {
  statement_id  = "AllowApiGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:us-east-1:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.my_api.id}/*/GET/myapi"
}