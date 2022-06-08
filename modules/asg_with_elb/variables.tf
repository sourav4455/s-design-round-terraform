variable "region" {
  type    = string
  default = "us-west-2"
}

variable "environment" {
  type    = string
}

variable "ami_id" {
  type    = string
}

variable "instance_type" {
  type    = string
}

variable "sg_ids" {
  type    = list
}

variable "userdata_filename" {
  type    = string
}

variable "key_name" {
  type    = string
}

variable "availability_zones" {
  type    = list 
}

variable "min_instance" {
  type    = list 
}

variable "max_instance" {
  type    = list 
}

variable "vpc" {
  type    = string 
}

variable "subnet_ids" {
  type    = list 
}

# Security Group of ELB

variable "elb_sg_name" {
  type    = string
}

variable "sg_inbound_elb" {
  type    = list
  default = [22,80,443]
}

variable "sg_outbound_elb" {
  type    = list
}

variable "ingress_cidr_elb" {
  type    = list
  default = ["0.0.0.0/0"]
}

variable "egress_cidr_elb" {
  type    = list
  default = ["0.0.0.0/0"]
}

# ELB variables

variable "elb_name" {
  type    = string
}

variable "internal_lb" {
  type    = bool
  default = true
}

variable "cross_zone_load_balancing" {
  type    = bool
  default = true
}

variable "connection_draining" {
  type    = bool
  default = true
}

variable "connection_draining_timeout" {
  type    = string
  default = "300"
}


variable "listeners" {
  type    = list
  default = [80, 443]
}

variable "listeners" {
  type = map(object({
    lb_port           = string
    instance_port     = string
    lb_protocol       = string
    instance_protocol = string
  }))
  default = {}
}

variable "health_check_healthy_threshold" {
  type    = string
  default = "2"
}

variable "health_check_unhealthy_threshold" {
  type    = string
  default = "2"
}

variable "health_check_timeout" {
  type    = string
  default = "3"
}

variable "health_check_interval" {
  type    = string
  default = "30"
}

variable "health_check_target" {
  type    = string
  default = "HTTP:8080/"
}