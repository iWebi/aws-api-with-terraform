import {Account} from "../../src/lib/types";
import axios, {AxiosRequestConfig, AxiosResponse} from "axios";
import {AccountRequest} from "../types";

// TODO: use custom domain url
const baseUrl = "https://yis6a1jw48.execute-api.us-east-2.amazonaws.com/default/v1.0/tenant:12345/account";

export async function createAccount(account: AccountRequest): Promise<AxiosResponse<Account>> {
    return await axios.post(baseUrl, account, defaultHeaders());
}

export async function getAccount(accountId: string): Promise<AxiosResponse<Account>> {
    const url = `${baseUrl}/${accountId}`;
    console.log("get url ", url);
    return await axios.get(url, defaultHeaders());
}

export async function updateAccount(account: AccountRequest, accountId:string): Promise<AxiosResponse<Account>> {
    const url = `${baseUrl}/${accountId}`;
    return await axios.put(url, account, defaultHeaders());
}

export async function deleteAccount(accountId: string): Promise<AxiosResponse<Account>> {
    const url = `${baseUrl}/${accountId}`;
    console.log("delete url ", url);
    return await axios.delete(url, defaultHeaders());
}

function defaultHeaders(): AxiosRequestConfig {
    return {
        // TODO: add Authorization
        headers: {
            "Content-Type": "application/json",
            Accept: "application/json",
            "x-auth-token": "_t_o_k_e_n_"
        },
        validateStatus: () => true
    }
}
