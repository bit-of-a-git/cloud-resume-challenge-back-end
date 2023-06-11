resource "aws_api_gateway_rest_api" "visitor_count" {
  name = "visitor_count"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_method" "GET" {
  rest_api_id   = aws_api_gateway_rest_api.visitor_count.id
  resource_id   = aws_api_gateway_rest_api.visitor_count.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "POST" {
  rest_api_id   = aws_api_gateway_rest_api.visitor_count.id
  resource_id   = aws_api_gateway_rest_api.visitor_count.root_resource_id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "GET_integration" {
  rest_api_id             = aws_api_gateway_rest_api.visitor_count.id
  resource_id             = aws_api_gateway_rest_api.visitor_count.root_resource_id
  http_method             = aws_api_gateway_method.GET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.GET_lambda_invoke
}

resource "aws_api_gateway_integration" "POST_integration" {
  rest_api_id             = aws_api_gateway_rest_api.visitor_count.id
  resource_id             = aws_api_gateway_rest_api.visitor_count.root_resource_id
  http_method             = aws_api_gateway_method.POST.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.POST_lambda_invoke
}

resource "aws_api_gateway_deployment" "my_deployment" {
  depends_on  = [aws_api_gateway_integration.GET_integration, aws_api_gateway_integration.POST_integration]
  rest_api_id = aws_api_gateway_rest_api.visitor_count.id
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.my_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.visitor_count.id
  stage_name    = "dev"
  depends_on    = [aws_api_gateway_account.demo]
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.visitor_count.id
  stage_name  = aws_api_gateway_stage.dev.stage_name
  method_path = "*/*"

  settings {
    logging_level          = "ERROR"
    throttling_burst_limit = 25
    throttling_rate_limit  = 50
  }
}

resource "aws_api_gateway_account" "demo" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_iam_role" "cloudwatch" {
  name = "api_gateway_cloudwatch_global"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "apigateway_cloudwatchlogs" {
  role       = aws_iam_role.cloudwatch.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_lambda_permission" "lambda_GET_permission" {
  statement_id  = "AllowMyAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.GET_lambda_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.visitor_count.execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "lambda_POST_permission" {
  statement_id  = "AllowMyAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.POST_lambda_name
  principal     = "apigateway.amazonaws.com"

  # The /*/*/* part allows invocation from any stage, method and resource path
  # within API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.visitor_count.execution_arn}/*/*/*"
}