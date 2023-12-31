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

resource "aws_iam_role_policy" "cloudwatch" {
  name = "default"
  role = aws_iam_role.cloudwatch.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_api_gateway_account" "demo" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_api_gateway_rest_api" "demo_api_gateway" {
  name = "terraform-demo-api"
  description = "Demo API using Terraform"
}

resource "aws_api_gateway_authorizer" "authorizer" {
  name                   = "Authorizer"
  rest_api_id            = aws_api_gateway_rest_api.demo_api_gateway.id
  authorizer_uri         = module.authorizer.invoke_arn
  type                   = "REQUEST"
  identity_source        = "method.request.header.x-auth-token"
  authorizer_result_ttl_in_seconds = "300"
}

resource "aws_api_gateway_request_validator" "authorizer" {
  name = aws_api_gateway_authorizer.authorizer.name
  rest_api_id = aws_api_gateway_rest_api.demo_api_gateway.id
  validate_request_body = false
  validate_request_parameters = true
}


resource "aws_api_gateway_deployment" "demo_api_gateway" {
  rest_api_id = aws_api_gateway_rest_api.demo_api_gateway.id
  triggers = {
    # TODO: this should be changed to checksum of packaged code for all lambdas
    redeployment = timestamp()
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "demo_api_gateway_stage" {
  stage_name    = terraform.workspace
  rest_api_id   = aws_api_gateway_rest_api.demo_api_gateway.id
  deployment_id = aws_api_gateway_deployment.demo_api_gateway.id
  xray_tracing_enabled = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.demo_api_access_log_group.arn
    format = file("${path.module}/access_log_settings_format.json")
  }
}

resource "aws_api_gateway_method_settings" "demo_api_gateway_settings" {
  depends_on  = [aws_api_gateway_stage.demo_api_gateway_stage]
  rest_api_id = aws_api_gateway_rest_api.demo_api_gateway.id
  stage_name  = terraform.workspace
  method_path = "*/*"

  settings {
    metrics_enabled        = true
    logging_level          = "INFO"
    data_trace_enabled     = true
    caching_enabled        = false
    unauthorized_cache_control_header_strategy = "SUCCEED_WITH_RESPONSE_HEADER"
    throttling_burst_limit = -1
    throttling_rate_limit  = -1
  }
}

resource "aws_cloudwatch_log_group" "demo_api_access_log_group" {
  name              = "demo_api_gateway_access_log"
  retention_in_days = 14
}

output "base_url" {
  value = aws_api_gateway_deployment.demo_api_gateway.invoke_url
}
