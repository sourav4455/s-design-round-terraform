
## Launch Configuration for a webserver
resource "aws_launch_configuration" "lc" {
  image_id         = "${var.ami_id}"
  instance_type    = "${var.instance_type}"
  security_groups  = "${var.sg_ids}"
  key_name         = "${var.key_name}"
  user_data        = "${file(var.userdata_filename)}"
  lifecycle {
    create_before_destroy = true
  }
}

## AutoScaling Group for webserver with HA
resource "aws_autoscaling_group" "asg" {
  launch_configuration = "${aws_launch_configuration.lc.id}"
  availability_zones   = "${var.availability_zones}"
  min_size             = "${var.min_instance}"
  max_size             = "${var.max_instance}"
  load_balancers       = ["${aws_elb.elb.name}"]
  health_check_type    = "ELB"
  tag {
    key                 = "Name"
    value               = "${var.environment}-asg"
    propagate_at_launch = true
  }
}

## Security Group for ELB
resource "aws_security_group" "elb_sg" {
  vpc_id      = "${var.vpc}"
  name        = "${var.environment}-${var.elb_sg_name}-sg"

  dynamic "ingress" {
    for_each = "${var.sg_inbound_elb}"
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = "${var.ingress_cidr_elb}"
    }
  }

  dynamic "egress" {
    for_each = "${var.sg_outbound_elb}"
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = "${var.egress_cidr_elb}"
    }
  }

### Creating ELB
resource "aws_elb" "elb" {
  name                        = "${var.environment}-${var.elb_name}"
  subnets                     = "${var.subnet_ids}"
  security_groups             = ["${aws_security_group.elb_sg.id}"]
  availability_zones          = "${var.availability_zones}"
  internal                    = "${var.internal_lb}"
  cross_zone_load_balancing   = "${var.cross_zone_load_balancing}"
  connection_draining         = "${var.connection_draining}"
  connection_draining_timeout = "${var.connection_draining_timeout}"

  health_check {
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    timeout             = "${var.health_check_timeout}"
    interval            = "${var.health_check_interval}"
    target              = "${var.health_check_target}"
  }

  dynamic "listener" {
    for_each = [for rule_obj in var.listeners : {
      lb_port           = rule_obj.lb_port
      instance_port     = rule_obj.instance_port
      lb_protocol       = rule_obj.lb_protocol
      instance_protocol = rule_obj.instance_protocol
    }]
    content {
      lb_port           = listener.value["lb_port"]
      lb_protocol       = listener.value["lb_protocol"]
      instance_port     = listener.value["instance_port"]
      instance_protocol = listener.value["instance_protocol"]
    }
  }

  tags = {
    Name        = "${var.environment}-elb"
    Environment = "${var.environment}"
  }
}
