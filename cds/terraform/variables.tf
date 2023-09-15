variable "db_password" {
  default     = "password"
  description = "Password for the RDS admin user"
}

variable "region" {
  default     = "us-east-1"
  description = "AWS region"
}

variable "vpc_cidr" {
  default     = "10.44" #first two octets of the VPC CIDR
  description = "CIDR for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  default = "cds-vpc-prod"
  type        = string
}

variable "tags_region" {
  description = "AWS region"
  type        = map(string)
  default = {
    region = "us-east-1"
  }
}

variable "tags_env" {
  description = "Environment"
  type        = map(string)
  default = {
    Environment = "prod"
  }
}

variable "vpc_remote_id" {
  description = "Peering destination vpc id"
  default = "value"
  type        = string
}

variable "vpc_remote_cidr" {
  description = "Peering destination vpc id"
  default = "value"
  type        = string
}
