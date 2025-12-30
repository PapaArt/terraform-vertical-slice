resource "aws_lb" "app_alb" {
    name               = "vertical-slice-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [aws_security_group.alb_sg.id]
    subnets            = [
        aws_subnet.public_vertical_subnet.id,
        aws_subnet.public_vertical_subnet_2.id
    ]
    tags = {
        Name = "vertical-slice-alb"
    }
}

resource "aws_lb_target_group" "backend_tg" {
    name     = "vertical-slice-tg"
    port     = var.app_port
    protocol = "HTTP"
    vpc_id   = aws_vpc.vertical_slice_vpc.id

    health_check {
        path                = "/swagger"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 5
        interval            = 30
        matcher             = "200-399"
    }

    tags = {
        Name = "vertical-slice-tg"
    }
}

resource "aws_lb_target_group_attachment" "backend_attach" {
    target_group_arn = aws_lb_target_group.backend_tg.arn
    target_id        = aws_instance.private_vertical_instance.id
    port             = var.app_port
}

resource "aws_lb_listener" "http_listener" {
    load_balancer_arn = aws_lb.app_alb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.backend_tg.arn
    }
}

