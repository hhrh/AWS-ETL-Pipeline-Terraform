resource "aws_lambda_function" "alphavantage_fetcher" {
  function_name = "AlphaVantageETLJob-Lambda"
  role          = var.lambda_role_arn
  
  # lambda_function.py contains function: "lambda_handler(_event, _context):..."
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  timeout       = 60

  filename      = "${path.module}/lambda_function.zip"

  # needed to detect hash changes ans redeploy code changes (i.e. if you rezip the file)
  source_code_hash = filebase64sha256("${path.module}/lambda_function.zip")

  environment {
    variables = {
      S3_BUCKET = var.bucket_name
      ALPHAVANTAGE_API_KEY = var.api_key
      STOCK_SYMBOL         = var.stock_symbol
    }
  }
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${aws_lambda_function.alphavantage_fetcher.function_name}"
  retention_in_days = 7
}