variable "name_prefix" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "was_sg_id" {
  type = string
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}
