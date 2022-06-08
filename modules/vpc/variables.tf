variable "region" {
  type    = string
  default = "us-west-2"
}

variable "environment" {
  type    = string
}

variable "vpc_cidr_range" {
  type    = string
}

variable "public_subnets_cidr" {
  type    = list
}

variable "private_subnets_cidr" {
  type    = list
}

# Private SG details

variable "sg_name" {
  type    = string
}

variable "sg_inbound_public_ports" {
  type    = list
  default = [22,80,443]
}

variable "sg_outbound_public_ports" {
  type    = list
}

variable "ingress_cidr_public_allowed" {
  type    = list
}

variable "egress_cidr_public_allowed" {
  type    = list
}

# Private SG details

variable "sg_inbound_private_ports" {
  type    = list
  default = [22,80,443]
}

variable "sg_outbound_private_ports" {
  type    = list
}

variable "ingress_sgid_private_allowed" {
  type    = list
}

variable "egress_cidr_private_allowed" {
  type    = list
}

variable "nacl_public_rules" {
  type = map(object({
    port     = string
    rule_num = string
    cidr     = string
  }))
  default = {}
}

variable "nacl_private_rules" {
  type = map(object({
    port     = string
    rule_num = string
    cidr     = string
  }))
  default = {}
}