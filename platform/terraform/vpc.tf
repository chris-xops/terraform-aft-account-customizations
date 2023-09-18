data "aws_availability_zones" "available" {}

data "aws_ssm_parameter" "vpc_name" {
  name = "/aft/account-request/custom-fields/vpc_name"
}
data "aws_ssm_parameter" "vpc_cidr" {
  name = "/aft/account-request/custom-fields/vpc_cidr"
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                 = data.aws_ssm_parameter.vpc_name
  cidr                 = "${data.aws_ssm_parameter.vpc_cidr}.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["${data.aws_ssm_parameter.vpc_cidr}.16.0/20", "${data.aws_ssm_parameter.vpc_cidr}.32.0/20", "${data.aws_ssm_parameter.vpc_cidr}.48.0/20"]
  public_subnets       = ["${data.aws_ssm_parameter.vpc_cidr}.64.0/20", "${data.aws_ssm_parameter.vpc_cidr}.80.0/20", "${data.aws_ssm_parameter.vpc_cidr}.96.0/20"]
  enable_nat_gateway   = true
  single_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "subnet_names" = "${data.aws_ssm_parameter.vpc_name} Subnets"
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
  bucket        = "${data.aws_ssm_parameter.vpc_name}-flow-logs"
  force_destroy = true

  tags = {
    Terraform   = "true"
    Environment = "rnd"
  }
}

