import { DeleteCommandInput, GetCommandInput, PutCommandInput } from "@aws-sdk/lib-dynamodb";
import { ulid } from "ulid";
import { ACCOUNT_TABLE } from "./constants";
import { deleteItem, getItem, putItem } from "./dynamodb";
import { Account, DynamoItemResponse } from "./types";
import { okResponse } from "./utils";

export async function addAccount(account: Account): Promise<DynamoItemResponse<Account>> {
  account.id = ulid();
  account.hashKey = hashKeyFor(account);
  account.rangeKey = account.id;
  account.created = account.updated = new Date().getTime();
  const params = {
    Item: account,
    TableName: ACCOUNT_TABLE,
  } as PutCommandInput;

  await putItem(params);
  return okResponse(account);
}

function hashKeyFor(account: Account): string {
  return `Account-${account.tenantId}`;
}

export async function getAccount(accountId: string, tenant: string): Promise<DynamoItemResponse<Account>> {
  const params = {
    Key: {
      hashKey: `Account-${tenant}`,
      rangeKey: accountId,
    },
    TableName: ACCOUNT_TABLE,
  } as GetCommandInput;
  return await getItem(params);
}

export async function updateAccount(account: Account): Promise<DynamoItemResponse<Account>> {
  account.hashKey = hashKeyFor(account);
  account.rangeKey = account.id;
  account.updated = new Date().getTime();

  const params = {
    Item: account,
    TableName: ACCOUNT_TABLE,
  } as PutCommandInput;

  await putItem(params);
  return okResponse(params.Item! as Account);
}

export async function deleteAccount(accountId: string, tenant: string): Promise<DynamoItemResponse<Account>> {
  const params = {
    Key: {
      hashKey: `Account-${tenant}`,
      rangeKey: accountId,
    },
    TableName: ACCOUNT_TABLE,
    ReturnValues: "ALL_OLD",
  } as DeleteCommandInput;
  return await deleteItem(params);
}
