# Define AWS Provider (at the root level)
provider "aws" {
  region = "us-east-1"
}

# Call the VPC Module
module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr         = "10.0.0.0/16"
  subnet_count     = 2
  availability_zones = ["us-east-1a", "us-east-1b"]
}

# Call the EC2 Module
module "ec2" {
  source          = "./modules/ec2"
  vpc_id         = module.vpc.vpc_id
  subnet_id      = module.vpc.public_subnets[0]
  instance_type  = "t2.micro"
  assign_public_ip = true
}

# Call the ALB & Auto Scaling Module
module "alb_asg" {
  source          = "./modules/alb_asg"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  instance_type  = "t2.micro"
}