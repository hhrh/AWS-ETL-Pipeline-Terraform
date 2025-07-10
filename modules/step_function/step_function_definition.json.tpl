{
  "Comment": "ETL pipeline: Lambda -> Glue Job -> Glue Crawler with failure handling",
  "StartAt": "RunLambda",
  "States": {
    "RunLambda": {
      "Type": "Task",
      "Resource": "arn:aws:states:::lambda:invoke",
      "Parameters": {
        "FunctionName": "${lambda_arn}"
      },
      "Next": "RunGlueJob",
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "Next": "NotifyFailure"
        }
      ]
    },
    "RunGlueJob": {
      "Type": "Task",
      "Resource": "arn:aws:states:::glue:startJobRun.sync",
      "Parameters": {
        "JobName": "${glue_job_name}",
        "Arguments": {
          "--JOB_NAME": "${glue_job_name}",
          "--input_path": "s3://${bucket_name}/raw/",
          "--output_path": "s3://${bucket_name}/processed/"
        }
      },
      "Next": "RunGlueCrawler",
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "Next": "NotifyFailure"
        }
      ]
    },
    "RunGlueCrawler": {
      "Type": "Task",
      "Resource": "arn:aws:states:::aws-sdk:glue:startCrawler",
      "Parameters": {
        "Name": "${crawler_name}"
      },
      "End": true,
      "Catch": [
        {
          "ErrorEquals": [
            "States.ALL"
          ],
          "Next": "NotifyFailure"
        }
      ]
    },
    "NotifyFailure": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "TopicArn": "${sns_topic_arn}",
        "Message": "Step Function Failed at one of the stages. Manual intervention required.",
        "Subject": "ETL Pipeline Failure - ${project} (${env})"
      },
      "Next": "FailState"
    },
    "FailState": {
      "Type": "Fail",
      "Error": "ETLFailure",
      "Cause": "A step in the ETL pipeline failed."
    }
  }
}