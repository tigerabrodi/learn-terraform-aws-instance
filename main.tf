terraform {

  cloud {
    organization = "{your-organization}"
    workspaces {
      name = "{name-of-your-workspace}"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "./modules/vpc"
}

module "ec2" {
  source    = "./modules/ec2"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.subnet_id
}

module "elb" {
  source            = "./modules/elb"
  elb_name          = "my-example-elb"
  subnet_ids        = [module.vpc.subnet_id]
  security_group_id = module.ec2.security_group_id
  instance_ids      = [module.ec2.instance_id]
}
