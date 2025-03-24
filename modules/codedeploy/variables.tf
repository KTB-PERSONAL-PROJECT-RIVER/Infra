variable "name_prefix" {}
variable "autoscaling_group_names" {
  type = list(string)
}

variable "target_group_name" {
  description = "ALB Target Group name"
}

variable "ec2_tag_name" {
  description = "EC2 태그 기반으로 배포 대상을 지정할 경우 사용 (Name=xxx)"
}

variable "codedeploy_role_arn" {}