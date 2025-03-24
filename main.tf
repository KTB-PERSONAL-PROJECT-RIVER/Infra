module "vpc" {
  source = "./modules/vpc"

  name_prefix = "myapp"
  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  private_was_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24"]
  private_db_subnet_cidrs   = ["10.0.21.0/24", "10.0.22.0/24"]
  azs = ["ap-northeast-2a", "ap-northeast-2c"]
}

module "alb" {
  source             = "./modules/alb"
  name_prefix        = "myapp"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
}

module "ec2_was" {
  source                     = "./modules/ec2_was"
  name_prefix                = "myapp"
  subnet_ids                 = module.vpc.private_was_subnet_ids
  key_name                   = "ubuntu_river"
  instance_type              = "t3.micro"
  was_sg_id                  = module.alb.was_sg_id
  target_group_arn           = module.alb.target_group_arn
}
