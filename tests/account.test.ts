import * as ulid from "ulid";
import {addAccount} from "../src/lib/account";
import {AccountRequest} from "./types";
jest.mock("../src/lib/dynamodb");
jest.mock("ulid");

const mockedUlid = ulid as jest.Mocked<typeof ulid>;
const randomness = "test-random-01HB4Y3WPZ965E7D6G8JG9610A";
mockedUlid.ulid.mockReturnValue(randomness);

describe("addAccount", () => {
    test("fails for invalid JSON request data", async () => {
        // when
        const response = await addAccount("foo", "12345");
        // then
        expect(response.statusCode).toBe(400);
        expect(response).toMatchSnapshot();
    });

    test("fails for missing mandatory fields in request data", async () => {
        // when
        const response = await addAccount('{"foo": "bar"}', "12345");
        // then
        expect(response.statusCode).toBe(400);
        expect(response).toMatchSnapshot();
    });

    test("creates account for valid request data", async () => {
        // given
        const tenantId = "tenant:12345";
        const accountReq:AccountRequest = {
            name: "test-account-name-"+new Date().getTime()
        }
        // when
        const response = await addAccount(JSON.stringify(accountReq), tenantId);
        // then
        expect(response.statusCode).toBe(200);
        const accountCreated = JSON.parse(response.body);
        expect(accountCreated).toMatchObject({
            id: randomness,
            name: accountReq.name,
            tenantId
        });
    });
});
