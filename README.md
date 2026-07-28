<p align="center">
  <img src="logo.png" alt="Torque-OS" width="220"/>
</p>

# mechanics-infra-db

Terraform infrastructure for the managed PostgreSQL database (AWS RDS) — part of the [Torque-OS](https://github.com/Torque-OS) Mechanics Software platform.

## Overview

Provisions an AWS RDS PostgreSQL instance inside the same VPC as the EKS cluster, replacing the in-cluster PostgreSQL deployment used in Phase 2.

## Tech Stack

- **IaC:** Terraform
- **Cloud:** AWS (RDS, Secrets Manager, Security Groups)
- **Database:** PostgreSQL 16
- **CI/CD:** GitHub Actions

## Architecture

```
VPC (from mechanics-infra-k8s)
└── Private Subnets
    └── RDS PostgreSQL 16
          ├── Multi-AZ (production)
          ├── Automated backups
          └── Security Group → allow EKS nodes only
```

## Project Structure

```
infra/
  main.tf          # RDS instance + subnet group + security group
  variables.tf
  outputs.tf
  providers.tf
  versions.tf
```

## Usage

```bash
cd infra
terraform init
terraform plan
terraform apply
```

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `aws_region` | AWS region | `us-east-1` |
| `db_name` | Database name | `mechanicssoftware` |
| `db_username` | Master username | `mechanic_admin` |
| `db_instance_class` | RDS instance type | `db.t3.micro` |
| `db_allocated_storage` | Storage in GB | `20` |

## Outputs

| Output | Description |
|--------|-------------|
| `db_endpoint` | RDS connection endpoint |
| `db_port` | PostgreSQL port (5432) |

## CI/CD

GitHub Actions pipeline:
- `terraform fmt` + `validate` + `plan` on every PR
- `terraform apply` on merge to `main`

## Related Repositories

| Repo | Purpose |
|------|---------|
| [mechanics-software](https://github.com/Torque-OS/mechanics-software) | Main API application |
| [mechanics-lambda](https://github.com/Torque-OS/mechanics-lambda) | Lambda CPF auth |
| [mechanics-infra-k8s](https://github.com/Torque-OS/mechanics-infra-k8s) | Terraform — VPC + EKS |
