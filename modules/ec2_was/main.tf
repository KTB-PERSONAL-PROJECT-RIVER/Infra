data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_launch_template" "lt" {
  name_prefix   = "${var.name_prefix}-lt-"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = var.ec2_profile_name
  }

  user_data = base64encode(templatefile("${path.module}/userdata.sh.tpl", {}))

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.was_sg_id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name_prefix}-was"
    }
  }
}

resource "aws_autoscaling_group" "asg-a" {
  name                = "${var.name_prefix}-asg-azone"
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = [var.subnet_ids[0]]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-was"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "asg-c" {
  name                = "${var.name_prefix}-asg-czone"
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = [var.subnet_ids[1]]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}-was"
    propagate_at_launch = true
  }
}