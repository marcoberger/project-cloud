output "eb_lb_dns_name" {
  value = data.aws_lb.eb_load_balancer.dns_name
}

