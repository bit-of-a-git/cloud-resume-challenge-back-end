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

resource "aws_lambda_function" "GET" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename         = data.archive_file.lambda_get.output_path
  function_name    = "Get-Hit-And-IP-Count${var.append}"
  role             = aws_iam_role.GET_lambda.arn
  handler          = "lambda_get.lambda_handler"
  source_code_hash = data.archive_file.lambda_get.output_base64sha256
  runtime          = "python3.10"

  environment {
    variables = {
      DYNAMODB_COUNT_TABLE_NAME = var.hit_counter_table_name
      DYNAMODB_IP_TABLE_NAME    = var.ip_address_table_name
    }
  }
}

data "archive_file" "lambda_get" {
  type        = "zip"
  source_file = "lambda_get.py"
  output_path = "lambda_get.zip"
}

resource "aws_iam_policy" "GET" {
  description = "Allows access to the hit count and IP address databases."

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
        Resource = [var.hit_counter_table_arn, var.ip_address_table_arn]
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "GET" {
  policy_arn = aws_iam_policy.GET.arn
  role       = aws_iam_role.GET_lambda.name
}

resource "aws_iam_role_policy_attachment" "GET_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.GET_lambda.name
}

resource "aws_iam_role" "GET_lambda" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "POST" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename         = data.archive_file.lambda_post.output_path
  function_name    = "Post-Hashed-IP${var.append}"
  role             = aws_iam_role.POST_lambda.arn
  handler          = "lambda_post.lambda_handler"
  source_code_hash = data.archive_file.lambda_post.output_base64sha256
  runtime          = "python3.10"

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.ip_address_table_name
    }
  }
}

data "archive_file" "lambda_post" {
  type        = "zip"
  source_file = "lambda_post.py"
  output_path = "lambda_post.zip"
}

resource "aws_iam_policy" "POST" {
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
resource "aws_iam_role_policy_attachment" "POST" {
  policy_arn = aws_iam_policy.POST.arn
  role       = aws_iam_role.POST_lambda.name
}

resource "aws_iam_role_policy_attachment" "POST_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.POST_lambda.name
}

resource "aws_iam_role" "POST_lambda" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}