# AWS Lambda deploy action for Python code

[![GitHubActions](https://img.shields.io/badge/listed%20on-GitHubActions-blue.svg)](https://github-actions.netlify.com/py-lambda)

Action works with functions written in Python 3.8 with dependencies on separate layer.

## Usage

Action deploys code from the repo to the AWS Lambda function, and installs/zips/deploys the dependencies as a separate layer.

## Inputs

  - *`lambda_function_name`* The Lambda function name. (required)
  - *`lambda_layer_arn`* The ARN of the Lambda layer for dependencies. (optional)
  - *`requirements_txt`* The name for the requirements.txt file. (Defaults is `requirements.txt`)
  - *`lambda_region`* Lambda function region name (Default is `us-east-1`)

Note, that if `lambda_layer_arn` wasn't defined in action call or `requirements_txt` wasn't changed last commit - only lambda code will be deployed, without dependencies. It could be useful during lambda development, but dependencies never change or deploy lambda code without dependencies. 

## Environment variables
### AWS Credentials
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY

Credentials are used by `awscli` for lambda code deployment to AWS. 

Below you can find minimal policy requirements for these credentials. Also see example how to use github secrets for credentials transition. **Don't commit working AWS credentials** into your repo even for private one! Use github repo secrets for such purpose.

## Example action code:

### Deploy lambda:
```yaml
name: Deploy lambda 

on:
  push:
    branches:
      - master

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@master
    - name: Deploy code to Lambda
      uses: denzalman/lambda-python-action@v2.0.0
      with:
        lambda_layer_arn: 'arn:aws:lambda:us-east-1:<AWS_ACCOUNT_ID>:layer:<lambda_layer_name>'
        lambda_function_name: 'lambda_function_name'
        lambda_region: 'us-east-1'
        requirements_txt: 'requirements.txt'
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
        "lambda:*"
      ],
      "Resource": [
        "arn:aws:lambda:*:<AWS_ACCOUNT_ID>:function:<lambda_function_name>*"
      ]
    }
  ]
}
```


