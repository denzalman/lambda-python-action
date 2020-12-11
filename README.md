# AWS Lambda deploy action for Python code

[![GitHubActions](https://img.shields.io/badge/listed%20on-GitHubActions-blue.svg)](https://github-actions.netlify.com/py-lambda)

Action works with functions written in Python 3.8 with dependencies on separate layer.



## AWS Policy

Minimal AWS credentials policy for the action: 

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


