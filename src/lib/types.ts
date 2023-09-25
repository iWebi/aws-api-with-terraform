export interface BaseEntity {
  hashKey: string;
  rangeKey?: string;
  created: number;
  updated: number;
}

export interface Account extends BaseEntity {
  tenantId: string;
  id: string;
  name: string;
}

export interface AppError {
  body: string;
  statusCode: number;
  statusType: string;
}

export interface DynamoItemResponse<T> {
  body: T;
  statusCode: number;
  statusType: string;
}
