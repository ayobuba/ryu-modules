
terraform {
  required_version = ">= 0.12, < 0.13"
//  backend "s3" {
//    key = "stage/services/webserver-cluster/terraform.state"
//
//  }
}


resource "aws_launch_configuration" "example" {
  image_id = var.ami
  instance_type = var.instance_type
  security_groups = [aws_security_group.instance.id]
  user_data = data.template_file.user-data.rendered

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier = data.aws_subnet_ids.default.ids
  target_group_arns = [aws_alb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size


  tag {
    key = "Name"
    propagate_at_launch = true
    value = var.cluster_name
  }
}

resource "aws_lb" "example" {
  name = var.cluster_name
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.default.ids
  security_groups = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port = local.http_port
  protocol = "HTTP"
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
}

resource "aws_alb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100
  action {
    type = "forward"
    target_group_arn = aws_alb_target_group.asg.arn
  }
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}


resource "aws_alb_target_group" "asg" {
  name = var.cluster_name
  port = var.http_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}


resource "aws_security_group" "alb" {
  name = "${var.cluster_name}-alb"

}

  resource "aws_security_group_rule" "allow_http_inbound" {
    type              = "ingress"
    security_group_id = aws_security_group.alb.id

    from_port   = local.http_port
    to_port     = local.http_port
    protocol    = local.tcp_protocol
    cidr_blocks = local.all_ips
  }

  resource "aws_security_group_rule" "allow_all_outbound" {
    type              = "egress"
    security_group_id = aws_security_group.alb.id

    from_port   = local.any_port
    to_port     = local.any_port
    protocol    = local.any_protocol
    cidr_blocks = local.all_ips
  }

resource "aws_security_group" "instance" {
  name = "${var.cluster_name}-instance"


}

  resource "aws_security_group_rule" "allow_traffic_ingress_instance" {
    from_port = local.http_port
    protocol = local.tcp_protocol
    security_group_id = aws_security_group.instance.id
    to_port = local.http_port
    type = "ingress"
    cidr_blocks = local.all_ips
  }


