output "endpoint" {
  value = join("", aws_rds_cluster.aurora-cluster.*.endpoint)
}