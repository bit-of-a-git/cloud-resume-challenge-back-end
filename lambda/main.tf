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

resource "aws_iam_policy" "AllowGetVisitorDB" {
  name        = "AllowGetVisitorDB"
  description = "Allows access to the visitor count database."

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
        Resource = [var.visitor_table_arn, var.ip_address_table_arn]
      },
    ]
  })
}

resource "aws_iam_policy" "AllowUpdateIPAddressDB" {
  name        = "AllowUpdateIPAddressDB"
  description = "Allows access to the ip address database."

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
        Resource = var.ip_address_table_arn
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "AllowGetVisitorDB-Attachment" {
  policy_arn = aws_iam_policy.AllowGetVisitorDB.arn
  role       = aws_iam_role.GET_lambda.name
}

resource "aws_iam_role_policy_attachment" "AllowUpdateIPAddressDB-Attachment" {
  policy_arn = aws_iam_policy.AllowUpdateIPAddressDB.arn
  role       = aws_iam_role.POST_lambda.name
}

resource "aws_iam_role_policy_attachment" "GET_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.GET_lambda.name
}

resource "aws_iam_role_policy_attachment" "POST_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.POST_lambda.name
}

resource "aws_iam_role" "GET_lambda" {
  name               = "IAM_Role_for_GET_Lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role" "POST_lambda" {
  name               = "IAM_Role_for_POST_lambda"
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
  filename         = data.archive_file.lambda_get.output_path
  function_name    = "VisitorCount"
  role             = aws_iam_role.GET_lambda.arn
  handler          = "lambda_get.lambda_handler"
  source_code_hash = data.archive_file.lambda_get.output_base64sha256
  runtime          = "python3.10"
  
  environment {
    variables = {
      DYNAMODB_COUNT_TABLE_NAME = var.visitor_table_name
      DYNAMODB_IP_TABLE_NAME = var.ip_address_table_name
    }
  }
}

resource "aws_lambda_function" "VisitorUpdate" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename         = data.archive_file.lambda_update.output_path
  function_name    = "VisitorUpdate"
  role             = aws_iam_role.POST_lambda.arn
  handler          = "lambda_update.lambda_handler"
  source_code_hash = data.archive_file.lambda_update.output_base64sha256
  runtime          = "python3.10"

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.ip_address_table_name
    }
  }
}