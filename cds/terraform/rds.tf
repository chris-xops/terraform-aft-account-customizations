resource "aws_db_subnet_group" "cds_rnd_db_subnet_group" {
  name       = "cds_rnd_db_subnet_group"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_db_subnet_group" "cds_rnd_db_subnet_group2" {
  name       = "cds_rnd_db_subnet_group_2"
  provider   = aws.us-west-1
  subnet_ids = module.vpc2.private_subnets
}

resource "aws_kms_key" "kms_rds_key" {
  description             = "RDS KMS Key"
  deletion_window_in_days = 7
}

resource "aws_kms_key_policy" "kms_rds_policy" {
  key_id = aws_kms_key.kms_rds_key.id

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "key-default-1",
    Statement = [
      {
        Sid       = "Enable IAM User Permissions",
        Effect    = "Allow",
        Principal = "*",
        Action    = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
        ],
        Resource  = "*",
      },
    ],
  })
}



resource "aws_db_instance" "primary" {
  allocated_storage         = 20
  storage_type              = "gp2"
  engine                    = "mysql"
  engine_version            = "5.7"
  instance_class            = "db.t2.small"
  username                  = "admin"
  password                  = random_password.password.result
  backup_retention_period   = 7
  parameter_group_name      = "default.mysql5.7"
  db_subnet_group_name      = aws_db_subnet_group.cds_rnd_db_subnet_group.name
  storage_encrypted         = true
  identifier                = "cds-rds-primary"
  final_snapshot_identifier = "cds-rds-primary-final-snapshot"
  skip_final_snapshot       = false
  multi_az                  = true
  vpc_security_group_ids    = [aws_security_group.cds_rnd_rds_sg.id]

  kms_key_id = aws_kms_key.kms_rds_key.arn


  tags = {
    Name = "CDS RND Primary RDS"
  }
}

resource "aws_db_instance" "read_replica" {
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.small"
  parameter_group_name    = "default.mysql5.7"
  backup_retention_period = 7
  replicate_source_db     = aws_db_instance.primary.identifier
  identifier              = "cds-rds-replica"
  storage_encrypted       = true
  skip_final_snapshot     = true
  vpc_security_group_ids  = [aws_security_group.cds_rnd_rds_sg.id]

  kms_key_id = aws_kms_key.kms_rds_key.arn

  tags = {
    Name = "CDS RND Read Replica RDS"
  }
}

resource "aws_db_instance" "standby_replica" {
  provider                = aws.us-west-1
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.small"
  parameter_group_name    = "default.mysql5.7"
  backup_retention_period = 7
  replicate_source_db     = aws_db_instance.primary.identifier
  identifier              = "cds-rds-standby"
  storage_encrypted       = true
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.cds_rnd_db_subnet_group2.name
  vpc_security_group_ids  = [aws_security_group.cds_rnd_rds_sg2.id]

  kms_key_id = aws_kms_key.kms_rds_key.arn
  tags = {
    Name = "Standby Replica RDS"
  }
}


resource "aws_secretsmanager_secret" "database_credentials" {
  name = "CDS_RND_Secret"
}

resource "aws_secretsmanager_secret_version" "database_credentials_version" {
  secret_id = aws_secretsmanager_secret.database_credentials.id
  secret_string = jsonencode({
    username = "admin",
    password = random_password.password.result
  })
}

resource "random_password" "password" {
  length  = 16
  upper   = true
  number  = true
  lower   = true
  special = false
  #override_special = "/!@#'$%^&*()"
}