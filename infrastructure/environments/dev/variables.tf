variable "region" {
  description = "The dfault AWS Region"
  default     = "eu-central-1"
}

variable "environment" {
  description = "The environment of the application. Can be development (dev), staging (stage) or production (prod)"
  default     = "dev"
}

variable "team" {
  description = "The name of the team"
  default     = "jedis"
}

variable "project" {
  description = "The name of the project"
  default     = "project-cloud"
}

