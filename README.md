# AWS Lambda deploy action for Python code

[![GitHubActions](https://img.shields.io/badge/listed%20on-GitHubActions-blue.svg)](https://github-actions.netlify.com/py-lambda)

Action works with functions written in Python 3.8 with dependencies on separate layer.

## Usage

Action deploys code from the repo to the AWS Lambda function, and installs/zips/deploys the dependencies as a separate layer.

## Inputs

  - *`lambda_layer_arn`* The ARN of the Lambda layer for dependencies. (required)
  - *`lambda_function_name`* The Lambda function name. (required)
  - *`requirements_txt`* The name for the requirements.txt file. (Defaults is `requirements.txt`)
  - *`lambda_region`* Lambda function region name (Default is `us-east-1`)

## Environment variables
### AWS Credentials
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY

It's used by `awscli` for deploy code to AWS. 

Below you can find minimal policy requirements for these credentials. Also see example how to use github secrets for secrets transition. **Don't commit working AWS credentials** into your repo even for private one! Use only secrets for this purpose.

## Example action code:
```yaml
name: deploy-lambda
on:
  push:
    branches:
      - master
jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@master
    - name: Deploy code to Lambda
      uses: denzalman/lambda-python-action@v1.0.0
      with:
        lambda_layer_arn: 'arn:aws:lambda:us-east-1:123456789012:layer:lambda-layer'
        lambda_name: 'my-lambda-function-name'
        lambda_region: 'us-east-1'
      env:
        AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
        AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
```

## AWS Policy

Minimal AWS credentials policy needed for the action credentials: 

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "iam:ListRoles",
        "lambda:UpdateFunctionCode",
        "lambda:CreateFunction",
        "lambda:UpdateFunctionConfiguration"
      ],
      "Resource": "*"
    }
  ]
}
```


