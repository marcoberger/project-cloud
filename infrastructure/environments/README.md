# Environment modules
The modules contained in this folder represent a collection of AWS resources, which make up an environment. Each environment module is contained in a folder, that is named like the environment. The _main.tf_ file of each environment calls several common modules. Dependencies between the common modules are resolved by exporting variables from one module and passing them to another common module.

## Remote state
The environment state is stored remotely. It's transferred from and to the S3 bucket, that was created by applying the scripts in the _account_ module. Each environment should be be saved to the remote state using a specific prefix. You can see the prefix in the _key_ variables value below. It's prefixed with the environment identifier _dev_.
```hcl 
terraform {
  required_version = ">=0.11.13"

  backend "s3" {
    bucket         = "dev-jedis-project-cloud-tf-state"
    key            = "dev/jedis/project-cloud/application/state.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "dev-jedis-project-cloud-tf-state-lock"
  }
}
```

## Environment identifier
The environment identifier is used to prefix the AWS resources in order to avoid name clashes when running multiple environments in one AWS account. It has to be adjusted for each environment within the _main.tf_ file.
```hcl
locals {
  enviroment_identifier = "dev"
}
```
