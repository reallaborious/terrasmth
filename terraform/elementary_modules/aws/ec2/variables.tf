variable "instance_name" { type = string }
variable "ami" { type = string }
variable "instance_type" { type = string }
variable "key_name" { type = string, default = null }
variable "subnet_id" { type = string }
variable "network_interface_id" { type = string, default = null }
variable "security_group_ids" { type = list(string) }
variable "associate_public_ip_address" { type = bool, default = false }
variable "aws_region" { type = string }
variable "tags" { type = map(string) default = {} }
variable "user_data" { type = string, default = null }
variable "iam_instance_profile" { type = string, default = null }
