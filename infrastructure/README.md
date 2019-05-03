# Project-cloud infrastructure

The project-cloud infrastructure is represented by terraform modules. You can find those modules here - account, environments and modules.

**Prerequisites**
- Python and pip
- Terraform
- AWS Command Line Interface

## Account
This module is used to set up a AWS account. It's usually applied only once and does not include remote state.

## Environments
For each environment there is on environment Terraform module. The environment module calls a collection of common modules contained in _modules_. Those common modules can be reused to create certain resources.

## Modules
This folder contains common, reusable modules. The models contain resources, that a clustered in logical units like backend infrastructure, frontend infrastructure or roles and permissions.
