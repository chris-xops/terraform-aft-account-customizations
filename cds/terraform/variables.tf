variable "db_password" {
  default     = "password"
  description = "Password for the RDS admin user"
}

variable "region" {
  default     = "us-east-1"
  description = "AWS region"
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
  default = "vpc-0d6d1c65352219720"
  type        = string
}

variable "vpc_remote_cidr" {
  description = "Peering destination vpc id"
  default = "10.46.0.0/16"
  type        = string
}
