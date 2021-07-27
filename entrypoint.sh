#!/bin/bash
set -e

######

echo "AWS configuration..."
aws configure set default.region "${INPUT_LAMBDA_REGION}"

######

echo "Installing dependencies..."
mkdir dependencies
pip install --target=python -r "${INPUT_REQUIREMENTS_TXT}"

######

echo "Zipping dependencies..."
zip -r python.zip ./python
rm -rf python

######

echo "Publishing dependencies layer..."
response=$(aws lambda publish-layer-version --layer-name "${INPUT_LAMBDA_LAYER_ARN}" --zip-file fileb://python.zip) --compatible-runtimes python3.8
VERSION=$(echo $response | jq '.Version')
rm python.zip

######

echo "Deploying lambda main code..."
zip -r lambda.zip . -x \*.git\*
aws lambda update-function-code --function-name "${INPUT_LAMBDA_FUNCTION_NAME}" --zip-file fileb://lambda.zip

######

echo "Updating lambda layer version..."
aws lambda update-function-configuration --function-name "${INPUT_LAMBDA_FUNCTION_NAME}" --layers "${INPUT_LAMBDA_LAYER_ARN}:${VERSION}"

######

echo "${INPUT_LAMBDA_FUNCTION_NAME} function was deployed successfully."
