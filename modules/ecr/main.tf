resource "aws_ecr_repository" "spring" {
  name = var.repository_name

  image_tag_mutability = "MUTABLE"

  tags = {
    Name = var.repository_name
  }
}
