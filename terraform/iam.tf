
resource "aws_iam_role" "lambda-execution" {
  name = "lambda-execution"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "myapp-lambda-dynamodb-policy" {
  name = "LambdaDynamoDB"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:*"
            ],
            "Resource": [
                "${aws_dynamodb_table.Accounts.arn}*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda-dynamodb-attachment" {
  role       = aws_iam_role.lambda-execution.name
  policy_arn = aws_iam_policy.myapp-lambda-dynamodb-policy.arn
}
