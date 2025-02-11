# Task 4: Deploy ALB and Auto Scaling

# Security Group for ALB (Allows HTTP)
resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ALB-sg" }
}

# Create the Application Load Balancer
resource "aws_lb" "app_alb" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets           = var.public_subnets

  tags = { Name = "App-alb" }
}

# Target Group for Auto Scaling instances
resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# Listener for ALB to forward traffic to Target Group
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Security Group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

  tags = { Name = "EC2-sg" }
}

# Launch Template for EC2 instances
resource "aws_launch_template" "web_server_lt" {
  name_prefix   = "web-server-template"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  network_interfaces {
    security_groups = [aws_security_group.ec2_sg.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install -y apache2
    echo "Hello from Auto Scaling!" | sudo tee /var/www/html/index.html
    sudo systemctl enable apache2
    sudo systemctl start apache2
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "WebServer" }
  }
}

# Auto Scaling Group (ASG)
resource "aws_autoscaling_group" "app_asg" {
  vpc_zone_identifier  = var.public_subnets
  desired_capacity     = 1
  min_size            = 1
  max_size            = 3
  health_check_type   = "EC2"

  launch_template {
    id      = aws_launch_template.web_server_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  tag {
    key                 = "Name"
    value               = "AutoScalingInstance"
    propagate_at_launch = true
  }
}
