variable "aws_region" {
  type        = string
  description = "AWS Region."
  default     = "us-east-2"
}

variable "app_name" {
  type        = string
  description = "UpRunningTasks"
  default     = "app"
}

variable "app_instance" {
  type        = string
  description = "Application instance name (ie. honolulu, customer_name, department, etc.)."
  default     = "instance"
}

variable "app_stage" {
  type        = string
  description = "Application stage (ie. dev, prod, qa, etc)."
  default     = "dev"
}

variable "global_tags" {
  type = map(string)

  default = {
    Provisioner = "Terraform"
    Owner       = "shekarau buba"
  }
}

variable "ami" {
  type = string
  description = "Default ami used in the tutorial"
  default = "ami-0c55b159cbfafe1f0"
}

variable "instance_type" {
  type = string
  description = "default instance type"

}

variable "http_port" {
  type = number
  description = "http port"
  default = 8080
}

variable "cluster_name" {
  description = "The name of the cluster resources"
  type = string
}

variable "db_remote_state_bucket" {
  description = "The name of the s3 bucket for the database remote state"
  type = string
}

variable "db_remote_state_key" {
  description = "The path for the datbase remote state in s3"
  type = string
}

variable "min_size" {
  type = number
  description = "The minimum number of EC2 instance in the ASG"
}

variable "max_size" {
  type = number
  description = "The maximum number of EC2 instance in the ASG"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

