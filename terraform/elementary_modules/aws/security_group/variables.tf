variable "name" { type = string }
variable "vpc_id" { type = string }
variable "ingress_rules" {
  description = "List of ingress rules (maps with from_port,to_port,protocol,cidr_blocks)"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}
variable "tags" { type = map(string) default = {} }
variable "aws_region" { type = string }
