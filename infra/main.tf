module "vpc" {
  source = "./modules/vpc"

}

module "ecr" {
  source = "./modules/ecr"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}