resource "aws_glue_crawler" "crawler" {
  name = "${var.project}-${var.env}-crawler"

  role = var.glue_role_arn

  database_name = var.glue_database_name

  s3_target {
    path = "s3://${var.bucket_name}/processed/"
  }

  table_prefix = "${var.project}_"

  configuration = jsonencode({
    Version = 1.0,
    CrawlerOutput = {
      Partitions = {
        AddOrUpdateBehavior = "InheritFromTable"
      }
    }
  })

  depends_on = [aws_glue_catalog_database.catalog_db]
}

resource "aws_glue_catalog_database" "catalog_db" {
  name = var.glue_database_name
}

data "aws_caller_identity" "current" {}