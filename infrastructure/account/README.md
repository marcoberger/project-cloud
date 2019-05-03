# Account module

This terraform module contains a Terraform script which is used to initialize an AWS account. The naming for the resources will be hard-coded and referred to in the other terraform packages. It will create the S3 bucket and the DynamoDB, which are used to handle the terraform remote state. It's supposed to be applied only once after the AWS account creation and works with local state.

## Resources
The following resources will be created:
- versioned S3 bucket for storing the terraform remote state
- DynamoDB for state locking

## Hot to use it
Run the following commands to use the terraform package:
```bash
terraform init
terraform apply
```
