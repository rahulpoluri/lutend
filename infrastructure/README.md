# Lutend Infrastructure

This directory contains Terraform infrastructure as code for deploying the Lutend platform.

## Structure

- `modules/` - Reusable Terraform modules for different infrastructure components

  - `compute/` - Container orchestration (ECS/GKE/AKS)
  - `database/` - Database resources (RDS/CloudSQL/Azure DB)
  - `networking/` - VPC, subnets, load balancers
  - `storage/` - Object storage (S3/GCS/Blob)
  - `cache/` - Redis/Memcached
  - `monitoring/` - Logging, metrics, alerting

- `providers/` - Cloud provider-specific implementations

  - `aws/` - AWS provider configuration
  - `gcp/` - Google Cloud Platform configuration
  - `azure/` - Microsoft Azure configuration

- `environments/` - Environment-specific configurations
  - `dev/` - Development environment
  - `staging/` - Staging environment
  - `production/` - Production environment

## Usage

1. Choose your cloud provider
2. Navigate to the appropriate environment directory
3. Initialize Terraform: `terraform init`
4. Plan changes: `terraform plan`
5. Apply changes: `terraform apply`

## Prerequisites

- Terraform >= 1.5.0
- Cloud provider CLI tools (AWS CLI, gcloud, or Azure CLI)
- Appropriate cloud credentials configured
