# only alpha numeric and hyphen is allowed in name
# alb target group
resource "aws_lb_target_group" "external_target_g" {
  name        = "external-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.custom_vpc.id
}


resource "aws_lb_target_group_attachment" "ec2_1_target_g" {
  target_group_arn  = aws_lb_target_group.external_target_g.arn
  target_id         = aws_instance.ec2_1.id
  port              = 80
}


resource "aws_lb_target_group_attachment" "ec2_2_target_g" {
  target_group_arn  = aws_lb_target_group.external_target_g.arn
  target_id         = aws_instance.ec2_2.id
  port              = 80
}


# ALB
resource "aws_lb" "external_alb" {
  name                = "external-ALB"
  internal            = false
  load_balancer_type  = "application"
  security_groups     = [aws_security_group.web_sg.id]
  subnets             = [aws_subnet.public_subnet1.id,aws_subnet.public_subnet2.id]

  tags = {
      name = "external-ALB"
  }
}

# create ALB listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.external_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.external_target_g.arn
  }
}