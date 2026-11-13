data "archive_file" "python_function" {
  type        = "zip"
  source_file = "${path.module}/src/hello.py"
  output_path = "${path.module}/build/hello.zip"
}

data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = "hello-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "python_function" {
  function_name    = "hello"
  role             = aws_iam_role.lambda.arn
  runtime          = "python3.13"
  handler          = "hello.handler"
  filename         = data.archive_file.python_function.output_path
  source_code_hash = data.archive_file.python_function.output_base64sha256
  timeout          = 10
}
