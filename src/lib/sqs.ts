import { SendMessageCommand, SendMessageCommandInput, SQSClient } from "@aws-sdk/client-sqs";
import * as AWSXRay from "aws-xray-sdk-core";
import {Account} from "./types";

const sqsClient = buildSQSClient();

function buildSQSClient() {
  const { IS_OFFLINE } = process.env;
  const offlineOptions = {
    region: "localhost",
    endpoint: "http://localhost:9324",
  };
  return IS_OFFLINE
    ? new SQSClient(offlineOptions as any)
    : AWSXRay.captureAWSv3Client(new SQSClient({} as any));
}

function getNotificationsQueueName(): string {
  const { IS_OFFLINE, NOTIFICATION_QUEUE_URL } = process.env;
  return IS_OFFLINE ? "http://localhost:9324/queue/accountnotifications.fifo" : NOTIFICATION_QUEUE_URL!;
}

export async function sendNewAccountMessage(account: Account) {
  const sendMessageInput = {
    QueueUrl: getNotificationsQueueName()!,
    MessageBody: JSON.stringify(account),
    MessageGroupId: `Account-${account.id}-${account.tenantId}`,
  } as SendMessageCommandInput;
  await sqsClient.send(new SendMessageCommand(sendMessageInput));
}
