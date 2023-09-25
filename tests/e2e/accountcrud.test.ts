import {AccountRequest} from "../types";
import {ulid} from "ulid";
import {createAccount, deleteAccount, getAccount, updateAccount} from "./httputils";

describe("Account CRUD", () => {
    const randomness = ulid();
    let accountId = "";
    const accountReq:AccountRequest = {
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
})
