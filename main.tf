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

module "iam" {
  source = "./modules/iam"
  role_name = "myapp-ec2-codedeploy-role"
}

module "ec2_was" {
  source                     = "./modules/ec2_was"
  name_prefix                = "myapp"
  subnet_ids                 = module.vpc.private_was_subnet_ids
  key_name                   = "ubuntu_river"
  instance_type              = "t3.micro"
  was_sg_id                  = module.alb.was_sg_id
  ec2_profile_name = module.iam.iam_instance_profile_name
  target_group_arn           = module.alb.target_group_arn
}

module "ecr" {
    source = "./modules/ecr"
    repository_name = "spring-boot-app"
}

module "codedeploy" {
    source = "./modules/codedeploy"
    name_prefix = "myapp"
    autoscaling_group_names = [
        module.ec2_was.asg_a_name,
        module.ec2_was.asg_c_name
    ]
    target_group_name = module.alb.target_group.name
    ec2_tag_name = "myapp-was"
}

module "codedeploy_s3" {
  source      = "./modules/s3_codedeploy"
  bucket_name = "river-spring-codedeploy-bucket"
}

module "s3_frontend" {
  source = "./modules/s3_frontend"
}