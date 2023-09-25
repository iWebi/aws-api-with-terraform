import { updateAccount } from "../lib/account";
import { APIGatewayEvent } from "aws-lambda";

export const handler = async (event: APIGatewayEvent) => {
    const pathParameters = event.pathParameters!;
    return await updateAccount(event.body!, pathParameters.accountId!, pathParameters.tenant!);
};
