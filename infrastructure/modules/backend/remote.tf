data "aws_iam_instance_profile" "eb_instanceprofile" {
  name = "aws-elasticbeanstalk-ec2-role"
}

data "aws_lb" "eb_load_balancer" {
  arn = aws_elastic_beanstalk_environment.eb_environment.load_balancers[0]
}

