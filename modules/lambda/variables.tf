variable "bucket_name" {
  type = string
}

variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "api_key" {
  description = "AlphaVantage API key"
  type        = string
  sensitive   = true
}

variable "stock_symbol" {
  description = "Stock symbol to fetch (e.g. AAPL)"
  type        = string
  default = "AAPL"
}

variable "lambda_role_arn" {
  description = "IAM role ARN for the Lambda function"
  type        = string
}