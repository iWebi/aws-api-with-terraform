import { APIGatewayEvent } from "aws-lambda";
import {authorize} from "../lib/auth";

export const handler = async (event: APIGatewayEvent) => {
    return await authorize(event);
};
