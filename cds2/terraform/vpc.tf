data "aws_availability_zones" "available" {}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                 = var.vpc_name
  cidr                 = "${var.vpc_cidr}.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["${var.vpc_cidr}.16.0/20", "${var.vpc_cidr}.32.0/20", "${var.vpc_cidr}.48.0/20"]
  public_subnets       = ["${var.vpc_cidr}.64.0/20", "${var.vpc_cidr}.80.0/20", "${var.vpc_cidr}.96.0/20"]
  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "subnet_names" = "CDS Subnets"
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
  bucket        = "${var.vpc_name}-flow-logs"
  force_destroy = true

  tags = {
    Terraform   = "true"
    Environment = "rnd"
  }
}

