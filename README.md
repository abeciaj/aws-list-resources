# AWS Lambda Function for Listing AWS Resources

This project deploys a Python script as an AWS Lambda function to list AWS resources and send the results via email using Amazon SES. The deployment is automated using Terraform.

## Prerequisites
1. AWS Account
2. Terraform
3. AWS CLI
4. Python 3.10 or higher
5. Verified SES Emails

## Lambda Deployment Steps
1. Create a virtual environment and install dependencies:
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```
2. Create a deployment package:
```bash
mkdir lambda_package
cp aws_list_resources.py requirements.txt lambda_package/
pip install -r requirements.txt --target lambda_package/
cd lambda_package
zip -r ../lambda_package.zip .
cd ..
```
3. Initialize and apply the Terraform configuration:
```bash
terraform init
terraform apply
```

## Test Lambda Function
1. Use the following test event:
```bash
{
  "regions": "us-east-1",
  "include_resource_types": "AWS::EC2::*,AWS::Lambda::*,AWS::S3::*",
  "exclude_resource_types": "",
  "only_show_counts": false,
  "profile": null
}
```
