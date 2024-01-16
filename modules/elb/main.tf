resource "aws_elb" "example_elb" {
  name            = var.elb_name
  subnets         = var.subnet_ids
  security_groups = [var.security_group_id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  # Health checks are crucial for ELB to ensure traffic is only sent to healthy instances. If an instance fails a health check, ELB stops sending traffic to it until it passes health checks again.
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }

  instances                   = var.instance_ids
  cross_zone_load_balancing   = true # Distributes traffic evenly across all registered instances in all enabled Availability Zones.
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = var.elb_name
  }
}
