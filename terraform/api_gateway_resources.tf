locals {
  rest_api_id = aws_api_gateway_rest_api.demo_api_gateway.id
  authorizer_id = aws_api_gateway_authorizer.authorizer.id
}
# /v1.0/{tenant}/account related resources
resource "aws_api_gateway_resource" "root" {
  rest_api_id = local.rest_api_id
  parent_id   = aws_api_gateway_rest_api.demo_api_gateway.root_resource_id
  path_part   = "v1.0"
}

resource "aws_api_gateway_resource" "tenant" {
  rest_api_id = local.rest_api_id
  parent_id   = aws_api_gateway_resource.root.id
  path_part   = "{tenant}"
}

resource "aws_api_gateway_resource" "account" {
  rest_api_id = local.rest_api_id
  parent_id   = aws_api_gateway_resource.tenant.id
  path_part   = "account"
}

resource "aws_api_gateway_resource" "accountId" {
  rest_api_id = local.rest_api_id
  parent_id   = aws_api_gateway_resource.account.id
  path_part   = "{accountId}"
}

module "createAccountApi" {
  source = "./modules/api-gateway-proxy"
  resource_id = aws_api_gateway_resource.account.id
  http_method = "POST"
  invoke_arn = module.addAccountLambda.invoke_arn


  authorizer_id = local.authorizer_id
  rest_api_id   = local.rest_api_id
}

module "getAccountApi" {
  source = "./modules/api-gateway-proxy"

  resource_id = aws_api_gateway_resource.accountId.id
  http_method = "GET"
  invoke_arn = module.getAccountLambda.invoke_arn


  authorizer_id = local.authorizer_id
  rest_api_id   = local.rest_api_id
}

module "updateAccountApi" {
  source = "./modules/api-gateway-proxy"

  resource_id = aws_api_gateway_resource.accountId.id
  http_method = "PUT"
  invoke_arn = module.updateAccountLambda.invoke_arn


  authorizer_id = local.authorizer_id
  rest_api_id   = local.rest_api_id
}

module "deleteAccountApi" {
  source = "./modules/api-gateway-proxy"

  resource_id = aws_api_gateway_resource.accountId.id
  http_method = "DELETE"
  invoke_arn = module.deleteAccountLambda.invoke_arn


  authorizer_id = local.authorizer_id
  rest_api_id   = local.rest_api_id
}
