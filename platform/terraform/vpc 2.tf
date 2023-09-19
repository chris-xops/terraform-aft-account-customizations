provider "aws" {
  region = "us-west-1"
}
  

data "aws_availability_zones" "available" {}

data "aws_ssm_parameter" "vpc_name_2" {
  name = "/aft/account-request/custom-fields/vpc_name_2"
}
data "aws_ssm_parameter" "vpc_cidr_2" {
  name = "/aft/account-request/custom-fields/vpc_cidr__2"
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                 = data.aws_ssm_parameter.vpc_name.value
  cidr                 = "${data.aws_ssm_parameter.vpc_cidr_2.value}.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["${data.aws_ssm_parameter.vpc_cidr_2.value}.16.0/20", "${data.aws_ssm_parameter.vpc_cidr_2.value}.32.0/20", "${data.aws_ssm_parameter.vpc_cidr_2.value}.48.0/20"]
  public_subnets       = ["${data.aws_ssm_parameter.vpc_cidr_2.value}.64.0/20", "${data.aws_ssm_parameter.vpc_cidr_2.value}.80.0/20", "${data.aws_ssm_parameter.vpc_cidr_2.value}.96.0/20"]
  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "subnet_names" = "${data.aws_ssm_parameter.vpc_name.value} Subnets"
  }

}

resource "aws_iam_role" "vpc-flow" {
  name = "vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = "rnd"
  }
}

resource "aws_s3_bucket" "vpc-prod-flow-logs" {
  bucket        = "${data.aws_ssm_parameter.vpc_name_2.value}-flow-logs"
  force_destroy = true

  tags = {
    Terraform   = "true"
    Environment = "rnd"
  }
}

