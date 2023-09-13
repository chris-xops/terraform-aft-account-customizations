output "primary_endpoint" {
  value = aws_db_instance.primary.endpoint
}

output "password_secret_arn" {
  value = aws_secretsmanager_secret.database_credentials.arn
}