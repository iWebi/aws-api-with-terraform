import { getAccount } from "../lib/account";
import { APIGatewayEvent } from "aws-lambda";

export const handler = async (event: APIGatewayEvent) => {
    const pathParameters = event.pathParameters!;
    return await getAccount(pathParameters.accountId!, pathParameters.tenant!);
};
