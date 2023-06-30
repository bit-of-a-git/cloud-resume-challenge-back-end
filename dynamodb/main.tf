resource "aws_dynamodb_table" "visitor" {
  name           = "visitor_table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "record_id"

  attribute {
    name = "record_id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "visitor_count" {
  table_name = aws_dynamodb_table.visitor.name
  hash_key   = aws_dynamodb_table.visitor.hash_key
  item = jsonencode({
    "record_id" : { "S" : "0" },
    "visitor_count" : { "N" : "0" }
  })

  lifecycle {
    ignore_changes = [
      item,
    ]
  }
}

resource "aws_appautoscaling_target" "visitor_table_read_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.visitor.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "visitor_table_read_policy" {
  name               = "dynamodb-read-capacity-utilization-${aws_appautoscaling_target.visitor_table_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.visitor_table_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.visitor_table_read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.visitor_table_read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = 70
  }
}

resource "aws_appautoscaling_target" "visitor_table_write_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.visitor.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "visitor_table_write_policy" {
  name               = "dynamodb-write-capacity-utilization-${aws_appautoscaling_target.visitor_table_write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.visitor_table_write_target.resource_id
  scalable_dimension = aws_appautoscaling_target.visitor_table_write_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.visitor_table_write_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = 70
  }
}

resource "aws_dynamodb_table" "ip_address" {
  name           = "ip_addresses"
  billing_mode   = "PROVISIONED"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "hashed_ip_address"

  attribute {
    name = "hashed_ip_address"
    type = "S"
  }
  
  ttl {
 // enabling TTL
  enabled = true 
  
  // the attribute name which enforces TTL, must be a number
  attribute_name = "timestamp" 
 }
}

resource "aws_appautoscaling_target" "ip_address_table_read_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.ip_address.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "ip_address_table_read_policy" {
  name               = "dynamodb-read-capacity-utilization-${aws_appautoscaling_target.ip_address_table_read_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ip_address_table_read_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ip_address_table_read_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ip_address_table_read_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    target_value = 70
  }
}

resource "aws_appautoscaling_target" "ip_address_table_write_target" {
  max_capacity       = 10
  min_capacity       = 1
  resource_id        = "table/${aws_dynamodb_table.ip_address.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "ip_address_table_write_policy" {
  name               = "dynamodb-write-capacity-utilization-${aws_appautoscaling_target.ip_address_table_write_target.resource_id}"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ip_address_table_write_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ip_address_table_write_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ip_address_table_write_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    target_value = 70
  }
}