variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name (used to locate VPC and subnets)"
  type        = string
  default     = "mechanics-software"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "mechanicssoftware"
}

variable "db_username" {
  description = "Master database username"
  type        = string
  default     = "mechanic_admin"
}

variable "db_password" {
  description = "Master database password"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}
