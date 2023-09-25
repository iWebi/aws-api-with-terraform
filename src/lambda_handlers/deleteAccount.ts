import { deleteAccount } from "../lib/account";
import { APIGatewayEvent } from "aws-lambda";

export const handler = async (event: APIGatewayEvent) => {
    const pathParameters = event.pathParameters!;
    return await deleteAccount(pathParameters.accountId!, pathParameters.tenant!);
};
