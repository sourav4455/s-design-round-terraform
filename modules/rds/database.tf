# AWS RDS creation
resource "aws_rds_cluster" "aurora-cluster" {
  cluster_identifier              = "${lower(var.cluster_identifier)}"
  database_name                   = "${lower(var.database_name)}"
  deletion_protection             = "${var.deletion_protection}"
  engine                          = "${var.engine}"
  engine_mode                     = "${var.engine_mode}"
  engine_version                  = "${var.engine_version}"
  db_cluster_parameter_group_name = length(var.db_cluster_parameter_group) != 0 ? aws_rds_cluster_parameter_group.aurora-cluster-parameter-group[var.cluster_identifier].name : null
  master_username                 = "${var.username}"
  master_password                 = "${var.password}"
  backup_retention_period         = "${var.retention_period}"
  preferred_backup_window         = "${var.backup_window}"
  preferred_maintenance_window    = "${var.maintenance_window}"
  db_subnet_group_name            = "${var.db_subnet_group_name}"
  final_snapshot_identifier       = "${var.cluster_identifier}"
  vpc_security_group_ids          = "${var.security_group_id}"
  apply_immediately               = "${var.apply_immediately}"
  allow_major_version_upgrade     = "${var.allow_major_version_upgrade}"

  snapshot_identifier             = "${var.snapshot_identifier}"
  copy_tags_to_snapshot           = true

  tags {
    Name        = "${var.environment}-rds"
    Environment = "${var.environment}"
  }

  lifecycle {
    ignore_changes = [
      final_snapshot_identifier
    ]
  }
}

# DB Paramater group
resource "aws_rds_cluster_parameter_group" "aurora-cluster-parameter-group" {
  for_each    = "${var.db_cluster_parameter_group}"
  family      = each.value.family
  name        = "${lower(var.cluster_identifier)}-${each.value.family}" # parameter group identifier
  description = each.value.description

  dynamic "parameter" {
    for_each = var.db_cluster_parameter_group[each.key].parameters

    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

# DB Instance
resource "aws_rds_cluster_instance" "aurora-cluster-instance" {
  apply_immediately                     = "${var.apply_immediately}"
  count                                 = "${var.instance_count}"
  identifier                            = "${lower(var.cluster_identifier)}-cluster-instance-${count.index}"
  cluster_identifier                    = "${aws_rds_cluster.aurora-cluster.id}"
  instance_class                        = "${var.instance_class}"
  engine                                = "${aws_rds_cluster.aurora-cluster.engine}"
  engine_version                        = "${aws_rds_cluster.aurora-cluster.engine_version}"
  db_subnet_group_name                  = "${var.db_subnet_group_name}"
  performance_insights_enabled          = "${var.performance_insights_enabled}"
  performance_insights_retention_period = "${var.performance_insights_enabled ? var.performance_insights_retention_period : null}"
  publicly_accessible                   = false

  tags {
    Name        = "${var.environment}-rds-1"
    Environment = "${var.environment}"
  }

  lifecycle {
    ignore_changes = [
      engine_version
    ]
  }
}

resource "aws_route53_record" "aurora-cluster-private" {
  count   = 1

  zone_id = "${var.private_zone_id}"
  name    = aws_rds_cluster.aurora-cluster.endpoint
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster.aurora-cluster.endpoint]
}

resource "aws_route53_record" "aurora-cluster-public" {
  count   = 1

  zone_id = "${var.pubic_zone_id}"
  name    = aws_rds_cluster.aurora-cluster.endpoint
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster.aurora-cluster.endpoint]
}

resource "aws_route53_record" "aurora-instance-private" {
  count   = "${var.instance_count}"

  zone_id = "${var.private_zone_id}"
  name    = aws_rds_cluster_instance.aurora-cluster-instance[count.index].endpoint
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster_instance.aurora-cluster-instance[count.index].endpoint]
}

resource "aws_route53_record" "aurora-instance-public" {
  count   = "${var.instance_count}"

  zone_id = "${var.pubic_zone_id}"
  name    = aws_rds_cluster_instance.aurora-cluster-instance[count.index].endpoint
  type    = "CNAME"
  ttl     = "300"
  records = [aws_rds_cluster_instance.aurora-cluster-instance[count.index].endpoint]
}