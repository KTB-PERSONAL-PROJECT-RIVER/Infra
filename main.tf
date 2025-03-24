module "vpc" {
  source = "./modules/vpc"
  
  name_prefix = "myapp"
  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_was_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24"]
  private_db_subnet_cidrs   = ["10.0.21.0/24", "10.0.22.0/24"]
  azs = ["ap-northeast-2a", "ap-northeast-2c"]
}
