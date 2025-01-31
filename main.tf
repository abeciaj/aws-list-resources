# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy for Lambda
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeRegions",
          "ec2:Describe*",
          "ec2:Get*",
          "ec2:List*",
          "cloudformation:ListTypes",
          "cloudformation:Describe*",
          "lambda:List*",
          "lambda:Get*",
          "s3:List*",
          "s3:Get*",
          "cloudcontrol:ListResources",
          "sts:GetCallerIdentity",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ses:SendEmail",
          "ses:SendRawEmail",
          "cloudformation:ListResources"
        ]
        Resource = "*"
      }
    ]
  })
}

# Lambda Function
resource "aws_lambda_function" "aws_list_resources" {
  function_name = "aws-list-resources"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "aws_list_resources.lambda_handler"
  runtime       = "python3.10"

  filename         = "lambda_package.zip" # Path to your deployment package
  source_code_hash = filebase64sha256("lambda_package.zip")
  timeout = 300
  environment {
    variables = {
      REGIONS                = "us-east-1" # Default region
      INCLUDE_RESOURCE_TYPES = "*"
      EXCLUDE_RESOURCE_TYPES = ""
      ONLY_SHOW_COUNTS       = "false"
    }
  }
}

# Amazon SES Configuration
resource "aws_ses_email_identity" "sender_email" {
  email = "abeciaj23@gmail.com" # Replace with your verified sender email
}

resource "aws_ses_email_identity" "recipient_email" {
  email = "abeciaj23@gmail.com" # Replace with your verified recipient email
}

# CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.aws_list_resources.function_name}"
  retention_in_days = 14
}

# Outputs
output "lambda_function_name" {
  value = aws_lambda_function.aws_list_resources.function_name
}

output "lambda_function_arn" {
  value = aws_lambda_function.aws_list_resources.arn
}