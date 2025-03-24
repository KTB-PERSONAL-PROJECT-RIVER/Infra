variable "name_prefix" {}
variable "subnet_ids" {
  type = list(string)
}
variable "key_name" {}
variable "instance_type" {
  default = "t3.micro"
}
variable "was_sg_id" {}
variable "target_group_arn" {}
variable "ec2_profile_name" {}