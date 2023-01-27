resource "aws_autoscaling_group" "ec2-cluster" {
  name                 = "${var.ec2_instance_name}_auto_scaling_group"
  min_size             = var.autoscale_min
  max_size             = var.autoscale_max
  desired_capacity     = var.autoscale_desired
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.ec2.name #  aws_launch_configuration.ec2.name
  vpc_zone_identifier  = [aws_subnet.private-subnet-1.id, aws_subnet.private-subnet-2.id] #
  target_group_arns    = [aws_alb_target_group.default-target-group.arn]
}


