output "bastion_public_ip" {
    description = "The public IP address of the bastion host"
    value       = aws_instance.public_vertical_instance.public_ip
}

output "private_instance_id" {
    description = "The ID of the private EC2 instance"
    value       = aws_instance.private_vertical_instance.id
}

output "alb_dns_name" {
    description = "The DNS name of the Application Load Balancer"
    value       = aws_lb.app_alb.dns_name
}