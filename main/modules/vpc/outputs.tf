output "vpc" {
  value = aws_vpc.cluster_vpc
}

output "load_balancer_subnet_a_id" {
  value = aws_subnet.elb_a.id
}

output "load_balancer_subnet_b_id" {
  value = aws_subnet.elb_b.id
}

output "load_balancer_subnet_c_id" {
  value = aws_subnet.elb_c.id
}

output "ecs_subnet_a" {
  value = aws_subnet.ecs_a
}

output "ecs_subnet_b" {
  value = aws_subnet.ecs_b
}

output "ecs_subnet_c" {
  value = aws_subnet.ecs_c
}

output "alb_sg_id" {
  value = aws_security_group.load_balancer.id
}

output "ecs_sg_id" {
  value = aws_security_group.ecs_task.id
}

output "vpc_id" {
  value = aws_vpc.cluster_vpc.id
}
