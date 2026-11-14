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

variable "atlas_public_key" {
  description = "MongoDB Atlas programmatic access public key"
  type        = string
  sensitive   = true
}

variable "atlas_private_key" {
  description = "MongoDB Atlas programmatic access private key"
  type        = string
  sensitive   = true
}

variable "atlas_org_id" {
  description = "MongoDB Atlas organization ID used to create service projects"
  type        = string
}

variable "atlas_project_prefix" {
  description = "Prefix used for the MongoDB Atlas project names"
  type        = string
  default     = "mechanics"
}

variable "atlas_allowed_cidrs" {
  description = "NAT egress CIDRs allowed to reach Atlas; do not use 0.0.0.0/0"
  type        = set(string)

  validation {
    condition     = length(var.atlas_allowed_cidrs) > 0 && !contains(var.atlas_allowed_cidrs, "0.0.0.0/0")
    error_message = "Provide at least one restricted Atlas CIDR and never allow 0.0.0.0/0."
  }
}

variable "mongo_passwords" {
  description = "Password for each service MongoDB user"
  type        = map(string)
  sensitive   = true

  validation {
    condition = alltrue([
      for service in ["os-service", "billing-service", "execution-service"] :
      contains(keys(var.mongo_passwords), service) && length(var.mongo_passwords[service]) >= 16
    ])
    error_message = "mongo_passwords must contain os-service, billing-service and execution-service passwords of at least 16 characters."
  }
}
