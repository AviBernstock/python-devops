# Terraform AWS Infrastructure Project

## Overview

This Terraform project sets up an AWS infrastructure including a VPC, subnets, an EC2 instance, an Application Load Balancer (ALB), and an Auto Scaling group. It is designed to be modular and configurable.

## Features

- **Custom VPC** with public and private subnets.
- **Internet Gateway** for public subnet internet access.
- **EC2 Instance** with user-defined instance type and public IP assignment.
- **Security Groups** allowing SSH (port 22) and HTTP (port 80).
- **Application Load Balancer (ALB)** with a target group.
- **Auto Scaling** with a minimum of 1 and a maximum of 3 instances.

## Prerequisites

- Terraform installed on your machine.
- AWS CLI configured with appropriate credentials.

## Usage

### 1. Initialize Terraform

Run the following command to initialize the Terraform configuration:

```
terraform init
```

### 2. Plan the Deployment

Check what Terraform will create before applying:

```
terraform plan
```

### 3. Apply the Configuration

Deploy the infrastructure using:

```
terraform apply
```

### 4. View Outputs

After deployment, you can view the important outputs such as the public IP of the EC2 instance and the ALB DNS name:

```
terraform output
```

### 5. Destroy the Infrastructure

To remove all created resources, run:

```
terraform destroy
```

## Module Structure

This project is structured as a Terraform module for reusability. Key variables include:

- **VPC CIDR Range**
- **Subnet Count**
- **Instance Type**
- **Public IP Assignment**

## Modules and Variables

### VPC Module

- `vpc_cidr` (string) - The CIDR block for the VPC.
- `public_subnet_cidr` (string) - CIDR block for the public subnet.
- `private_subnet_cidr` (string) - CIDR block for the private subnet.

### EC2 Module

- `instance_type` (string) - The type of EC2 instance (default: t2.micro).
- `assign_public_ip` (bool) - Whether to assign a public IP.
- `security_group_ids` (list) - List of security group IDs to attach.

### ALB Module

- `alb_name` (string) - The name of the Application Load Balancer.
- `target_group_name` (string) - Name of the target group for EC2 instances.
- `auto_scaling_min` (number) - Minimum number of instances.
- `auto_scaling_max` (number) - Maximum number of instances.

## Debugging & Fixes

For debugging common Terraform issues, refer to the provided guide in Task 5.

## License

This project is open-source and available under the MIT License.

## Author

Avi Bernstock
