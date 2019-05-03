# Project-cloud common modules
The common modules are referenced und reused by the environment modules. They are not meant to be applied on it's own, but should rather be called by some other Terraform module.

## Backend module
The backend module creates all AWS resources that are needed to host the backend.
- Elastic Beanstalk environment and application
- S3 bucket for application version files

## Frontend module
The frontend module creates all AWS resources that are needed to host the frontend.
- S3 Bucket
- CloudFront distribution, origins and cache behaviours 

## Roles and Permissions module
This module creates AWS IAM roles and attaches permissions to those roles. The IAM roles are used by other common modules like the backend and the frontend.
