output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_port" {
  description = "RDS instance port"
  value       = aws_db_instance.this.port
}

output "db_name" {
  description = "Database name"
  value       = aws_db_instance.this.db_name
}

output "connection_string" {
  description = "PostgreSQL connection string (without password)"
  value       = "Host=${aws_db_instance.this.endpoint};Database=${aws_db_instance.this.db_name};Username=${aws_db_instance.this.username}"
  sensitive   = true
}

output "database_url_secret_arn" {
  description = "ARN of the Secrets Manager secret holding the full DB connection string"
  value       = aws_secretsmanager_secret.database_url.arn
}

output "mongo_secret_arns" {
  description = "ARNs of the per-service MongoDB connection string Secrets"
  value = {
    for service, secret in aws_secretsmanager_secret.mongo_url :
    service => secret.arn
  }
}

output "mongo_project_ids" {
  description = "MongoDB Atlas project IDs by service"
  value = {
    for service, project in mongodbatlas_project.service :
    service => project.id
  }
}
