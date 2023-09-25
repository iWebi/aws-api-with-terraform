locals {
  lambda_dir = "/tmp/api"
  layer = aws_lambda_layer_version.nodejs.arn
  role_arn = aws_iam_role.lambda-execution.arn
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission#source_arn
  source_arn = "${aws_api_gateway_rest_api.demo_api_gateway.execution_arn}/*/*"
}

module "addAccountLambda" {
  source = "./modules/lambda"

  function_name = "addAccount"
  lambda_dir    = local.lambda_dir
  layers        = [local.layer]
  name          = "addAccount"
  source_arn    = local.source_arn
  role_arn = local.role_arn
  depends_on = [aws_lambda_layer_version.nodejs]
}

module "getAccountLambda" {
  source = "./modules/lambda"

  function_name = "getAccount"
  lambda_dir    = local.lambda_dir
  layers        = [local.layer]
  name          = "getAccount"
  source_arn    = local.source_arn
  role_arn = local.role_arn
  depends_on = [aws_lambda_layer_version.nodejs]
}


module "updateAccountLambda" {
  source = "./modules/lambda"

  function_name = "updateAccount"
  lambda_dir    = local.lambda_dir
  layers        = [local.layer]
  name          = "updateAccount"
  source_arn    = local.source_arn
  role_arn = local.role_arn
  depends_on = [aws_lambda_layer_version.nodejs]
}
