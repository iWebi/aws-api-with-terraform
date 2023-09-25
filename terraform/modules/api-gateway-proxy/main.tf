variable "rest_api_id" {
  type = string
}

variable "resource_id" {
  type = string
}

variable "http_method" {
  type = string
}

variable "authorizer_id" {
  type = string
}


variable "invoke_arn" {
  type = string
}

resource "aws_api_gateway_method" "method" {
  rest_api_id = var.rest_api_id
  resource_id = var.resource_id
  http_method = var.http_method
  authorization = var.authorizer_id == "" ? "NONE" : "CUSTOM"
  authorizer_id = var.authorizer_id
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = var.rest_api_id
  resource_id = aws_api_gateway_method.method.resource_id
  http_method = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = var.invoke_arn
}
