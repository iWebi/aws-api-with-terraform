import { APIGatewayProxyResult } from "aws-lambda";
import * as repository from "./accountrepository";
import {Account, AppError} from "./types";
import { badRequestWith, errorResponse, isEmpty, successResponse } from "./utils";

export async function addAccount(accountRequest: string, tenant: string): Promise<APIGatewayProxyResult> {
  try {
    const account = validateAccountForCreateOrUpdate(accountRequest);
    account.tenantId = tenant;
    await repository.addAccount(account);
    // await sendNewAccountMessage(account);
    return successResponse(account, 200);
  } catch (err) {
    return errorResponse(err as AppError);
  }
}

function validateAccountForCreateOrUpdate(accountRequest: string): Account {
  let account: Account;
  try {
    account = JSON.parse(accountRequest);
  } catch (err) {
    throw badRequestWith("Invalid JSON payload");
  }
  // Dummy validations. JSON schema validators https://ajv.js.org can be considered instead
  if (isEmpty(account.name)) {
    throw badRequestWith("Missing mandatory field(s): name for account creation");
  }
  return account;
}

export async function getAccount(accountId: string, tenant: string): Promise<APIGatewayProxyResult> {
  try {
    const accountResponse = await repository.getAccount(accountId, tenant);
    return successResponse(accountResponse.body, 200);
  } catch (err) {
    return errorResponse(err as AppError);
  }
}

export async function deleteAccount(accountId: string, tenant: string): Promise<APIGatewayProxyResult> {
  try {
    const deleteResponse = await repository.deleteAccount(accountId, tenant);
    return successResponse(deleteResponse.body, 200);
  } catch (err) {
    return errorResponse(err as AppError);
  }
}

export async function updateAccount(
  accountRequest: string,
  accountId: string,
  tenant: string
): Promise<APIGatewayProxyResult> {
  try {
    const account = validateAccountForCreateOrUpdate(accountRequest);
    account.id = accountId;
    account.tenantId = tenant;
    const updateResponse = await repository.updateAccount(account);
    return successResponse(updateResponse.body);
  } catch (err) {
    return errorResponse(err as AppError);
  }
}
