# CodeDeploy Application
resource "aws_iam_role" "codedeploy_service_role" {
  name = "${var.name_prefix}-codedeploy-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codedeploy.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy" {
  role       = aws_iam_role.codedeploy_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}

resource "aws_codedeploy_app" "this" {
  name = "${var.name_prefix}-codedeploy-app"
  compute_platform = "Server"
}

# CodeDeploy Deployment Group
resource "aws_codedeploy_deployment_group" "this" {
  app_name              = aws_codedeploy_app.this.name
  deployment_group_name = "${var.name_prefix}-deployment-group"
  service_role_arn      = aws_iam_role.codedeploy_service_role.arn
  deployment_config_name = "CodeDeployDefault.AllAtOnce"

  autoscaling_groups = var.autoscaling_group_names

  deployment_style {
    deployment_type = "IN_PLACE"
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
  }

  load_balancer_info {
    target_group_info {
      name = var.target_group_name
    }
  }

  ec2_tag_filter {
    key   = "Name"
    type  = "KEY_AND_VALUE"
    value = var.ec2_tag_name
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}
