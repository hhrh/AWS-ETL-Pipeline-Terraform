#===#===# GLUE & GLUE CRAWLER #===#===#

# Glue assumed IAM Role
resource "aws_iam_role" "glue_role" {
  name = "${var.project}-${var.env}-glue-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "glue.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Glue assumed role-policy attachment
resource "aws_iam_role_policy_attachment" "glue_attach" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# Glue IAM role, access projects' S3 bucket
resource "aws_iam_policy" "glue_access_data_bucket" {
  name        = "${var.project}-${var.env}-glue-data-access"
  description = "Allow Glue to access the project S3 bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })
}

# Glue role-policy attachment for S3 bucket access
resource "aws_iam_role_policy_attachment" "glue_access_data_bucket" {
  role       = aws_iam_role.glue_role.name
  policy_arn = aws_iam_policy.glue_access_data_bucket.arn
}

#===#===# LAMBDA #===#===#

# Lambda IAM Role
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Lambda IAM Policy
resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_logging_and_s3"
  description = "Allow Lambda to log to CloudWatch and write to S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject"
        ],
        Resource = "arn:aws:s3:::mycompany-data-pipeline-dev-*/raw/*"
      }
    ]
  })
}

# Lambda role-policy attachment
resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

#===#===# STEP FUNCTION #===#===#

resource "aws_iam_role" "step_function_role" {
  name = "${var.project}-${var.env}-step-function-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "states.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "step_function_combined" {
  name = "${var.project}-${var.env}-step-combined-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "glue:StartJobRun",
          "glue:GetJobRun",
          "glue:GetJobRuns",
          "glue:BatchStopJobRun"
        ],
        Resource = var.glue_job_arn
      },
      {
      Effect = "Allow",
      Action = [
        "glue:StartCrawler"
      ],
      Resource = var.crawler_arn
      },
      {
        Effect = "Allow",
        Action = ["lambda:InvokeFunction"],
        Resource = [
          var.lambda_arn,
          "${var.lambda_arn}:*"
        ]
      },
      {
        Effect = "Allow",
        Action = ["sns:Publish"],
        Resource = var.failure_topic_arn
      },
      {
        Effect = "Allow",
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "step_combined" {
  role       = aws_iam_role.step_function_role.name
  policy_arn = aws_iam_policy.step_function_combined.arn
}

#===#===# EVENTBRIDGE SCHEDULER #===#===#

resource "aws_iam_role" "eventbridge_invoke_role" {
  name = "${var.project}-${var.env}-eventbridge-step-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "events.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "invoke_step_function" {
  name = "${var.project}-${var.env}-eventbridge-policy"
  role = aws_iam_role.eventbridge_invoke_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = "states:StartExecution",
      Resource = var.step_function_arn
    }]
  })
}