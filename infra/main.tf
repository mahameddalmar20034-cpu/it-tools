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

module "alb" {
  source            = "./modules/alb"
  alb_sg_id         = module.security.alb_sg_id
  public_subnet_ids = module.vpc.public_subnet_ids
  vpc_id            = module.vpc.vpc_id
  certificate_arn   = module.acm.certificate_arn




}

module "acm" {
  source             = "./modules/acm"
  domain_name        = "it.modalmar.co.uk"
  cloudflare_zone_id = "fe6f4d403b316ca868cf9734f2d76ab8"

}



