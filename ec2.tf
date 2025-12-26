data "aws_ami" "amazon_linux" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name   = "name"
        values = ["al2023-ami-2023.9.20251208.0-kernel-6.1-x86_64"]
    }
}

resource "aws_instance" "public_vertical_instance" {
    ami                          = data.aws_ami.amazon_linux.id
    instance_type                = var.instance_type
    subnet_id                    = aws_subnet.public_vertical_subnet.id
    vpc_security_group_ids       = [aws_security_group.public_ec2.id]
    associate_public_ip_address  = true

    key_name = var.key_pair_name

    tags = {
        Name = "${var.instance_name_public}-bastion"
    }
}

resource "aws_instance" "private_vertical_instance" {
    ami                         = data.aws_ami.amazon_linux.id
    instance_type               = var.instance_type
    subnet_id                   = aws_subnet.private_vertical_subnet.id
    vpc_security_group_ids      = [aws_security_group.private_ec2.id]

    user_data = <<-EOF
                #!/bin/bash
                yum update -y
                amazon-linux-extras install docker -y
                systemctl start docker
                systemctl enable docker

                docker pull papaart/verticalslicearchitecture:latest
                docker run -d -p ${var.app_port}:${var.app_port} papaart/verticalslicearchitecture:latest
            EOF

    tags = {
        Name = "vertical-slice-backend"
    }
}