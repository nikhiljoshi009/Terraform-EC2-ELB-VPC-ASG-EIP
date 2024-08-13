
resource "aws_lb" "nj_lb" {
  name               = "nikhil-lb-asg"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.nj_sg_for_elb.id]
  subnets            = [aws_subnet.nj_subnet_1.id, aws_subnet.nj_subnet_1a.id]
  depends_on         = [aws_internet_gateway.nj_gw]
}

resource "aws_lb_target_group" "nj_alb_tg" {
  name     = "nj-tf-lb-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.nj_main.id
}

resource "aws_lb_listener" "nj_front_end" {
  load_balancer_arn = aws_lb.nj_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nj_alb_tg.arn
  }
}
