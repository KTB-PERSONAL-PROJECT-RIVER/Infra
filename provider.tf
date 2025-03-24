provider "aws" {
    region = "ap-northeast-2"
    default_tags {
      tags = {
        Origin = "Created By Terraform"
      }
    }
}