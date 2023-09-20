# Crear el grupo de seguridad para RDS
resource "aws_security_group" "cds_rnd_rds_sg" {
  name        = "rds-sg"
  description = "Security group for RDS"
  vpc_id = module.vpc.vpc_id

  # Regla para permitir el tráfico desde la otra VPC a través de peering
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Cambia esto a la CIDR de la otra VPC
  }
}

resource "aws_security_group" "cds_rnd_rds_sg2" {
  provider = aws.us-west-1
  name        = "rds2-sg"
  description = "Security group for RDS"
  vpc_id = module.vpc2.vpc_id

  # Regla para permitir el tráfico desde la otra VPC a través de peering
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Cambia esto a la CIDR de la otra VPC
  }
}