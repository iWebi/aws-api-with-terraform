resource "aws_dynamodb_table" "Accounts" {
  name           = "Accounts"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "hashKey"
  range_key      = "rangeKey"

  attribute {
    name = "hashKey"
    type = "S"
  }

  attribute {
    name = "rangeKey"
    type = "S"
  }
}
