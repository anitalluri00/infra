<<<<<<< HEAD
=======
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

>>>>>>> 6f3b0ea (Local changes before pull)
locals {
  common_tags = merge(var.tags, {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}

resource "aws_sns_topic" "alerts" {
  name = "${var.project}-${var.environment}-alerts"

  tags = local.common_tags
}

resource "aws_sns_topic_subscription" "email" {
  for_each = toset(var.alert_email_endpoints)

  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = each.value
}

resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  count = var.rds_instance_id != "" ? 1 : 0

  alarm_name          = "${var.project}-${var.environment}-rds-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 60
  statistic           = "Average"
  threshold           = var.rds_cpu_threshold
  treat_missing_data  = "notBreaching"
  alarm_description   = "RDS CPU high"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    DBInstanceIdentifier = var.rds_instance_id
  }

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "redis_cpu" {
  count = var.redis_replication_group_id != "" ? 1 : 0

  alarm_name          = "${var.project}-${var.environment}-redis-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "EngineCPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = 60
  statistic           = "Average"
  threshold           = var.redis_cpu_threshold
  treat_missing_data  = "notBreaching"
  alarm_description   = "Redis engine CPU high"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    ReplicationGroupId = var.redis_replication_group_id
  }

  tags = local.common_tags
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  count = var.alb_arn_suffix != "" ? 1 : 0

  alarm_name          = "${var.project}-${var.environment}-alb-5xx-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = var.alb_5xx_threshold
  treat_missing_data  = "notBreaching"
  alarm_description   = "ALB target 5xx elevated"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }

  tags = local.common_tags
}
