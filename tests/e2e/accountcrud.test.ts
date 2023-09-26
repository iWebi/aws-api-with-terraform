import {AccountRequest} from "../types";
import {ulid} from "ulid";
import {createAccount, deleteAccount, getAccount, updateAccount} from "./httputils";
import axios, {AxiosError} from "axios";

describe("Account CRUD", () => {
    const randomness = ulid();
    let accountId = "";
    const accountReq: AccountRequest = {
        name: `test-account-${randomness}`
    };

    test("api allows to create account for valid request", async () => {
        // when
        const response = await createAccount(accountReq);
        // then
        expect(response.status).toBe(200);
        expect(response.data.id).toBeTruthy();
        // This is bad. Should be set in beforeAll()
        accountId = response.data.id;
    });

    test("api allows to fetch account using accountId", async () => {
        // when
        const response = await getAccount(accountId);
        // then
        expect(response.status).toBe(200);
        expect(response.data).toMatchObject({
            id: accountId,
            ...accountReq
        });
    });

    test("api allows to update account using accountId", async () => {
        // given
        const updatedAccount = {
            ...accountReq,
            active: true // new field
        }
        // when
        const response = await updateAccount(updatedAccount, accountId);
        // then
        expect(response.status).toBe(200);
        expect(response.data).toMatchObject({
            id: accountId,
            ...updatedAccount
        });
    });

    test("api allows to delete account using accountId", async () => {
        // when
        const response = await deleteAccount(accountId);
        // then
        expect(response.status).toBe(200);
        expect(response.data).toMatchObject({
            id: accountId,
            ...accountReq
        });
    });
});

describe("APIs Authorization", () => {
    const baseUrl = "https://yis6a1jw48.execute-api.us-east-2.amazonaws.com/default/v1.0/tenant:12345/account";
    const headers = {
        "Content-Type": "application/json",
        Accept: "application/json",
    };
    const captureAxiosError = async (call: () => void) => {
        try {
            await call();
        } catch (e) {
            return e as AxiosError;
        }
    }
    test("POST resource returns 401 without valid authorization token", async () => {
        // when
        const error: AxiosError = await captureAxiosError(async () => {

            await axios.post(baseUrl, '{"foo": "bar"}', {headers});
        });
        // then
        expect(error.response.status).toBe(401);
    });

    test("GET resource returns 401 without valid authorization token", async () => {
        // when
        const error: AxiosError = await captureAxiosError(async () => {

            await axios.get(baseUrl + "/12345", {headers});
        });
        // then
        expect(error.response.status).toBe(401);
    });

    test("PUT resource returns 401 without valid authorization token", async () => {
        // when
        const error: AxiosError = await captureAxiosError(async () => {

            await axios.put(baseUrl + "/12345", '{"foo": "bar"}', {headers});
        });
        // then
        expect(error.response.status).toBe(401);
    });

    test("DELETE resource returns 401 without valid authorization token", async () => {
        // when
        const error: AxiosError = await captureAxiosError(async () => {

            await axios.delete(baseUrl + "/12345", {headers});
        });
        // then
        expect(error.response.status).toBe(401);
    });
})
