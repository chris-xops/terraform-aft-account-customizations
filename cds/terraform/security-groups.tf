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
    cidr_blocks = ["10.44.0.0/16"] # Cambia esto a la CIDR de la otra VPC
  }
}