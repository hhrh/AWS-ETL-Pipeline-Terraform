variable "project" {
  description = "Project name"
  type        = string
  default     = "data-pipeline"
}

variable "env" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
  default     = "dev"
}

variable "alphavantage_api_key" {
  description = "AlphaVantage API key"
  type        = string
  sensitive   = true
}

variable "stock_symbol" {
  description = "Stock symbol to fetch (e.g. AAPL)"
  type        = string
}