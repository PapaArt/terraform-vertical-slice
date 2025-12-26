resource "aws_security_group" "public_ec2" {
    vpc_id = aws_vpc.vertical_slice_vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "private_ec2" {
    vpc_id = aws_vpc.vertical_slice_vpc.id

    ingress {
        from_port   = var.app_port
        to_port     = var.app_port
        protocol    = "tcp"
        security_groups = [aws_security_group.public_ec2.id]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        security_groups = [aws_security_group.public_ec2.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}