output "app_prefix" {
  value = "${local.name_prefix}"
}

output "alb_dns_name" {
  value = aws_lb.example.dns_name

}

output "asg_name" {
  value = aws_autoscaling_group.example.name
  description = "The name of the ASG"

}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}


