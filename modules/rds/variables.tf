variable "region" {
  type    = string
  default = "us-west-2"
}

variable "environment" {
  type    = string
}

variable "cluster_identifier" {
  type    = string
  default = ""
}

variable "database_name" {
  type    = string
  default = ""
}

variable "deletion_protection" {
  type    = bool
  default = false
}

variable "engine" {
  type    = string
  default = "aurora-postgresql"
}

variable "engine_mode" {
  type    = string
  default = ""
}

variable "engine_version" {
  type    = string
  default = ""
}

variable "instance_class" {
  type    = string
  default = ""
}

variable "username" {
  type    = string
  default = "adminuser"
}

variable "password" {
  type    = string
  default = ""
}

variable "retention_period" {
  type    = number
  default = 14
}

variable "backup_window" {
  type    = string
  default = "02:00-03:00"
}

variable "maintenance_window" {
  type    = string
  default = "Sat:01:00-Sat:01:30"
}

variable "db_subnet_group_name" {
  type    = string
  default = ""
}

variable "security_group_id" {
  type    = string
  default = ""
}

variable "apply_immediately" {
  type    = bool
  default = true
}

variable "allow_major_version_upgrade" {
  type    = bool
  default = true
}

variable "snapshot_identifier" {
  type        = string
  description = "Specifies whether or not to create this cluster from a snapshot. You can use either the name or ARN when specifying a DB cluster snapshot, or the ARN when specifying a DB snapshot."
  default     = ""
}

variable "db_cluster_parameter_group" {
  type = map(object({
    description = string
    family      = string
    parameters  = list(map(string))
  }))
  default = {}
}

variable "instance_count" {
  type    = string
  default = "1"
}

variable "performance_insights_enabled" {
  type        = bool
  default     = true
  description = "Whether or not to enable Performance Insights"
}

variable "performance_insights_retention_period" {
  type        = number
  default     = 7
  description = "The number of days to retain Performance Insights data"
}

variable "private_zone_id" {
  type    = string
}

variable "pubic_zone_id" {
  type    = string
}