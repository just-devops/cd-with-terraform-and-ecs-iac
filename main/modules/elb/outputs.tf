output "elb_name" {
  value = aws_lb.elb
}

output "elb_dns" {
  value = aws_lb.elb.dns_name
}

output "ecs_target_group" {
  value = aws_lb_target_group.ecs
}
