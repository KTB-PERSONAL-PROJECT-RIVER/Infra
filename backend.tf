terraform {
  backend "s3" {
    bucket         = "ktb-river-backend"
    key            = "dev/terraform.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "ktb-river-dynamo-lock"
  }
}
