data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "GetVisitorDB" {
  name        = "GetVisitorDB"
  description = "Allows access to the visitor count database."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Effect   = "Allow"
        Resource = var.visitor_table_arn
      },
    ]
  })
}

resource "aws_iam_policy" "UpdateVisitorDB" {
  name        = "UpdateVisitorDB"
  description = "Allows access to the visitor count database."

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchWriteItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
        ]
        Effect   = "Allow"
        Resource = var.visitor_table_arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "GetVisitorDB-Attachment" {
  policy_arn = aws_iam_policy.GetVisitorDB.arn
  role       = aws_iam_role.iam_for_GET_lambda.name
}

resource "aws_iam_role_policy_attachment" "UpdateVisitorDB-Attachment" {
  policy_arn = aws_iam_policy.UpdateVisitorDB.arn
  role       = aws_iam_role.iam_for_POST_lambda.name
}

resource "aws_iam_role_policy_attachment" "GETbasic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.iam_for_GET_lambda.name
}

resource "aws_iam_role_policy_attachment" "POSTbasic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.iam_for_POST_lambda.name
}

resource "aws_iam_role" "iam_for_GET_lambda" {
  name               = "iam_for_GET_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "iam_for_POST_lambda" {
  name               = "iam_for_POST_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "lambda_get" {
  type        = "zip"
  source_file = "lambda_get.py"
  output_path = "VisitorCount.zip"
}

data "archive_file" "lambda_update" {
  type        = "zip"
  source_file = "lambda_update.py"
  output_path = "VisitorUpdate.zip"
}

resource "aws_lambda_function" "VisitorCount" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename         = "VisitorCount.zip"
  function_name    = "VisitorCount"
  role             = aws_iam_role.iam_for_GET_lambda.arn
  handler          = "lambda_get.lambda_handler"
  source_code_hash = data.archive_file.lambda_get.output_base64sha256

  runtime = "python3.10"

}

resource "aws_lambda_function" "VisitorUpdate" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename         = "VisitorUpdate.zip"
  function_name    = "VisitorUpdate"
  role             = aws_iam_role.iam_for_POST_lambda.arn
  handler          = "lambda_update.lambda_handler"
  source_code_hash = data.archive_file.lambda_update.output_base64sha256

  runtime = "python3.10"

}