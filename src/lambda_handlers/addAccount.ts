import { addAccount } from "../lib/account";
import { APIGatewayEvent } from "aws-lambda";

export const handler = async (event: APIGatewayEvent) => {
    const pathParameters = event.pathParameters!;
    return await addAccount(event.body!, pathParameters.tenant!);
};
