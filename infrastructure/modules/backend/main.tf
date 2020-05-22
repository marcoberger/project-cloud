locals {
  tags = {
    Environment = var.environment
    Team        = var.team
    Project     = var.project
  }

  ressource_prefix = "${var.environment}-${var.team}-${var.project}"

  jar_file_name            = "project-cloud-0.1.0.jar"
  jar_file_path            = "../../../backend/build/libs/${local.jar_file_name}"
  greeting_controller_path = "/greeting"
  health_check_path        = "/actuator/health"
}

# Resources to manage - Elastic Beanstalk
# ========================================================================

resource "aws_s3_bucket_object" "s3_bucket_applicationversion_object" {
  bucket = aws_s3_bucket.s3_bucket_applicationversion.id
  key    = "beanstalk/${local.jar_file_name}"
  source = local.jar_file_path
  etag   = filemd5(local.jar_file_path)
}

resource "aws_elastic_beanstalk_application" "eb_app" {
  name        = "${local.ressource_prefix}-backend"
  description = "The backend application for the project-cloud project."
}

resource "aws_elastic_beanstalk_environment" "eb_environment" {
  name         = "${local.ressource_prefix}-backend-env"
  application  = aws_elastic_beanstalk_application.eb_app.name
  tier         = "WebServer"
  platform_arn = "arn:aws:elasticbeanstalk:${var.region}::platform/Java 8 running on 64bit Amazon Linux/2.10.7"

  version_label = aws_elastic_beanstalk_application_version.eb_app_version.name

  setting {
    name      = "IamInstanceProfile"
    namespace = "aws:autoscaling:launchconfiguration"
    value     = data.aws_iam_instance_profile.eb_instanceprofile.name
  }

  setting {
    name      = "StreamLogs"
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    value     = "true"
  }

  setting {
    name      = "DeleteOnTerminate"
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    value     = "false"
  }

  setting {
    name      = "RetentionInDays"
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    value     = "3"
  }

  setting {
    name      = "MinSize"
    namespace = "aws:autoscaling:asg"
    value     = "2"
  }

  setting {
    name      = "MaxSize"
    namespace = "aws:autoscaling:asg"
    value     = "3"
  }

  setting {
    name      = "Cooldown"
    namespace = "aws:autoscaling:asg"
    value     = "60"
  }

  setting {
    name      = "SystemType"
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    value     = "enhanced"
  }

  setting {
    name      = "RollingUpdateEnabled"
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    value     = "true"
  }

  setting {
    name      = "DeploymentPolicy"
    namespace = "aws:elasticbeanstalk:command"
    value     = "Rolling"
  }

  setting {
    name      = "LoadBalancerType"
    namespace = "aws:elasticbeanstalk:environment"
    value     = "application"
  }

  setting {
    name      = "HealthCheckPath"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = local.greeting_controller_path
  }

  setting {
    name      = "MatcherHTTPCode"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "200"
  }

  setting {
    name      = "HealthCheckInterval"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = "300"
  }

  setting {
    name      = "Port"
    namespace = "aws:elasticbeanstalk:environment:process:default"
    value     = var.backend_application_port
  }

  setting {
    name      = "HealthCheckPath"
    namespace = "aws:elasticbeanstalk:environment:process:actuator"
    value     = local.health_check_path
  }

  setting {
    name      = "MatcherHTTPCode"
    namespace = "aws:elasticbeanstalk:environment:process:actuator"
    value     = "200"
  }

  setting {
    name      = "HealthCheckInterval"
    namespace = "aws:elasticbeanstalk:environment:process:actuator"
    value     = "300"
  }

  setting {
    name      = "Port"
    namespace = "aws:elasticbeanstalk:environment:process:actuator"
    value     = var.backend_management_port
  }

  tags = local.tags
}

# Deployment of Backend jar file
# ========================================================================

resource "random_string" "app_version_suffix" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_s3_bucket" "s3_bucket_applicationversion" {
  bucket = "${local.ressource_prefix}-eb-applicationversion"

  tags = local.tags
}

resource "aws_elastic_beanstalk_application_version" "eb_app_version" {
  name        = "${local.ressource_prefix}-application-${random_string.app_version_suffix.result}"
  application = aws_elastic_beanstalk_application.eb_app.name
  description = "${var.project} application version created by terraform"
  bucket      = aws_s3_bucket.s3_bucket_applicationversion.id
  key         = aws_s3_bucket_object.s3_bucket_applicationversion_object.id
}

