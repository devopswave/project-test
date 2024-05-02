# Infrastructure as Code (IaC) with Terraform

This repository contains Terraform code to provision a simple AWS infrastructure for a development environment.

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- AWS account with appropriate permissions.
- AWS CLI configured with access key and secret key.

## Usage
1. Clone this repository to your local machine.
2. Navigate to the repository directory.
3. Run `terraform init` to initialize the working directory.
4. Run `terraform plan` to see the execution plan.
5. Run `terraform apply` to apply the changes and provision the infrastructure.

## Configuration
- `provider.tf`: Specifies the AWS provider and region.
- `variables.tf`: Defines input variables for customizing subnet CIDR blocks and availability zones.
- `main.tf`: Contains Terraform configuration for VPC, subnets, internet gateway, route table, security groups, EC2 instance, and RDS instance.
- `outputs.tf`: Defines output variables to display important information after provisioning.

## Infrastructure Components
- **VPC**: Virtual Private Cloud with CIDR block `10.0.0.0/16`.
- **Subnets**:
  - Public Subnets: `10.0.1.0/24`, `10.0.2.0/24`, `10.0.3.0/24`.
  - Private Subnets: `10.0.4.0/24`, `10.0.5.0/24`, `10.0.6.0/24`.
- **Internet Gateway**: Attached to the VPC for internet access.
- **Route Table**: Default route table with a route to the internet gateway.
- **Security Groups**:
  - `instance_sg`: Security group for EC2 instance allowing inbound traffic on port 80.
  - `db_sg`: Security group for RDS instance allowing inbound traffic on port 5432.
- **EC2 Instance**: t2.micro instance with Apache installed, serving a simple webpage.
- **RDS Instance**: PostgreSQL database instance with specified configuration.

## Outputs
- `instance_public_ip`: Public IP address of the EC2 instance.
- `instance_private_ip`: Private IP address of the EC2 instance.
- `db_instance_address`: Address of the RDS instance.
- `db_instance_arn`: ARN of the RDS instance.
- `db_instance_name`: Name of the RDS instance.
- `db_instance_endpoint`: Connection endpoint of the RDS instance.

## Author
##### @***a2b78***

Feel free to customize and extend this infrastructure according to your requirements.

