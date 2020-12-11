#!/bin/bash
set -e

######

echo "AWS configuration..."
aws configure set default.region "${INPUT_LAMBDA_REGION}"

######

echo "Installing dependencies..."
mkdir dependencies
pip install --target=dependencies -r "${INPUT_REQUIREMENTS_TXT}"

######

echo "Zipping dependencies..."
zip -r dependencies.zip ./dependencies
rm -rf dependencies

######

echo "Publishing dependencies layer..."
response=$(aws lambda publish-layer-version --layer-name "${INPUT_LAMBDA_LAYER_ARN}" --zip-file fileb://dependencies.zip)
VERSION=$(echo $response | jq '.Version')
rm dependencies.zip

######

echo "Deploying lambda main code..."
zip -r lambda.zip . -x \*.git\*
aws lambda update-function-code --function-name "${INPUT_LAMBDA_FUNCTION_NAME}" --zip-file fileb://lambda.zip

######

echo "Updating lambda layer version..."
aws lambda update-function-configuration --function-name "${INPUT_LAMBDA_FUNCTION_NAME}" --layers "${INPUT_LAMBDA_LAYER_ARN}:${VERSION}"

######

echo "${INPUT_LAMBDA_FUNCTION_NAME} function was deployed successfully."
