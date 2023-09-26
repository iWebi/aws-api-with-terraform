# Example boilerplate repo for creating Restful API using AWS API Gateway and Terraform
This repo will demonstrate terraform, AWS skills to create a Restful API using
- API Gateway
- Typescript based Lambda with NodeJS runtime
- DynamoDB for persistence of sample data
- Custom Authorizer to enforce secured API
- Swagger documentation hosted along with API
- Cloudwatch logs
- XRy for distributed tracing
- Terraform managing complete config management
- Jest based unit, end to end tests

# Setup

## NodeJS
API is deployed against NodeJS 18.x Lambda run time (latest supported version as of 09/26/2023).
You need node 18.x on your machine to run tests/develop. 
[nvm](https://github.com/nvm-sh/nvm) is recommended to manage Node version.
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
```
After nvm installation, install node using `nvm install 18; nvm use 18; node -v`

## Terraform
Install terraform version >= 1.5.7. [Choose relevant](https://developer.hashicorp.com/terraform/downloads) download+install option
```
> terraform --version
Terraform v1.5.7
on darwin_amd64
```

## Deploy
Install node dependencies including dev dependencies. (Required to run tests) 
```
npm i
```
To deploy, you need an AWS account with access to admin console.
- Logon to AWS admin console and create a `terraform` IAM user and attach `AdministratorAccess` IAM policy
- From  `Security credentials` tab of IAM user, download credentials (accessKey and secretAccessKey)
- Terraform configuration [main.tf](./terraform/main.tf) assumes an AWS profile `terraform-demo-prod` on your machine.
Create ~/.aws/config and ~/.aws/credentials

````
Contents of ~/.aws/config. You can choose AWS region of your choice

[profile terraform-demo-prod]
region=us-east-2
````

````
Contents of ~/.aws/credentials. Copy & pase the credentials obtained above

[terraform-demo-prod]
aws_access_key_id=AKXXXXXXXPK
aws_secret_access_key=AbXXXXXXXXXXXXXXXXXyg
````

- Run terraform commands from your project root dir. 
You can always adjust PATH to refer to terraform installed location to avoid typing the complete path each time 
```
./node_modules/.bin/terraform init
./node_modules/.bin/terraform apply
```

