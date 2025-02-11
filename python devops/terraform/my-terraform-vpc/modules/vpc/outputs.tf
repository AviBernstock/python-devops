output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "List of public subnets"
  value       = aws_subnet.public_subnet[*].id
}
