# You can use locals as shortcut for complicated variables
# ie. ${local.name_prefix}-vpc
locals {
  name_prefix   = "${var.app_name}-${var.app_instance}-${var.app_stage}"
  account_id    = "${data.aws_caller_identity.current.account_id}"
  account_alias = "${data.aws_iam_account_alias.current.account_alias}"
  tags          = "${merge(var.global_tags, map("App","${var.app_name}", "Instance", "${var.app_instance}", "Stage", "${var.app_stage}"))}"
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}
