#!/bin/bash
#set -e

if [ ! -d src/lambda_handlers ]
then
  echo "Usage: Run script from the root directory of this repo"
  exit 1
fi

#TODO: Make dependencies install and compilation optional to skip when deployed from local during dev process
npm ci
#clean up previous packaged lamdbas, if any
LAMBDA_PACKAGE_DIR=/tmp/api
if [ -d $LAMBDA_PACKAGE_DIR ]
then
  rm -rf $LAMBDA_PACKAGE_DIR
fi
mkdir -p "$LAMBDA_PACKAGE_DIR"
ROOT_DIR=$(pwd)

./node_modules/.bin/esbuild --bundle ./src/lambda_handlers/*.ts  --sourcemap=inline --platform=node --target=es2020 --outdir=$LAMBDA_PACKAGE_DIR --packages=external

# Create a zip for each lambda function. Copy the transpiled typescript sources into respective
# directories to zip
# This approach uses simple typscript compiler (tsc) to compile each file. Alternately, you could
# a bundler like webpack which offers other features such minification.
# But those are not really necessary for AWS Lambda. Lambda zips are not massive to influence Lambda cold start times.
echo "Packaging lambdas...."
cd ${LAMBDA_PACKAGE_DIR}
for i in *.js
do
  function_name=${i%.js}
  mkdir -p ${LAMBDA_PACKAGE_DIR}/${function_name}
  cp $i ${LAMBDA_PACKAGE_DIR}/${function_name}/
done

cd
mkdir -p ${LAMBDA_PACKAGE_DIR}/nodejs/nodejs
cp ${ROOT_DIR}/package*.json ${LAMBDA_PACKAGE_DIR}/nodejs/nodejs/
cd ${LAMBDA_PACKAGE_DIR}/nodejs/nodejs
# We could copy already installed node_modules from above.
# but it includes all dev dependencies which makes layer large
npm i --omit=dev
