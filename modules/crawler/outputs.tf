output "crawler_name" {
  description = "Name of the Glue Crawler"
  value       = aws_glue_crawler.crawler.name
}

output "crawler_arn" {
  description = "ARN of the Glue Crawler"
  value = aws_glue_crawler.crawler.arn
}