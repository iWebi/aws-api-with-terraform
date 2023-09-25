variable "name" {
  type = string
}

variable "lambda_dir" {
  type = string
}

variable "function_name" {
  type = string
}

variable "layers" {
  type = list(string)
}

variable "source_arn" {
  type = string
}

variable "role_arn" {
  type = string
}

variable "lambda_timeout" {
  type = string
  default = 15
}

variable "lambda_memory" {
  type = string
  default = 1024
}

variable "api_gateway" {
  type    = string
  default = 1
}

variable "nodejs_runtime" {
  type = string
  default = "nodejs18.x"
}

// lambda_dir should come from packageLambdas, so this is forced to run after that
data "archive_file" "zipfile" {
  type        = "zip"
  source_dir  = "${var.lambda_dir}/${var.name}"
  output_path = "${var.lambda_dir}/${var.name}.zip"
}

resource "aws_lambda_function" "function" {
  function_name    = var.function_name
  handler          = "${var.name}.handler"
  runtime          = var.nodejs_runtime
  role             = var.role_arn
  filename         = data.archive_file.zipfile.output_path
  source_code_hash = data.archive_file.zipfile.output_base64sha256
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory
  layers           = var.layers

  tracing_config {
    mode = "Active"
  }
}

resource "aws_lambda_permission" "permissions" {
  // 1 = enabled, 0 = disabled
  count         = var.api_gateway
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = var.source_arn

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/lambda/${aws_lambda_function.function.function_name}"
  retention_in_days = 14
}

output "invoke_arn" {
  value = aws_lambda_function.function.invoke_arn
}

output "arn" {
  value = aws_lambda_function.function.arn
}

output "function_name" {
  value = aws_lambda_function.function.function_name
}
