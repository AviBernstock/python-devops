output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2.instance_public_ip
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.alb_asg.alb_dns_name
}