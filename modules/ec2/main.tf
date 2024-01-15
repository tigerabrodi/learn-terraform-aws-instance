resource "aws_security_group" "app_server_sg" {
  name        = "app_server_sg"
  description = "Security group for the application server"
  vpc_id      = var.vpc_id

  # Inbound rules
  ingress {
    from_port   = 22 # SSH access
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ideally we should restrict to known IPs for better security
  }

  ingress {
    from_port   = 80 # HTTP access
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Same caution applies here
  }

  # Outbound rules (allowing all outbound traffic by default)

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 signifies all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app_server_sg"
  }
}

resource "aws_instance" "app_server" {
  ami                    = "ami-08d70e59c07c61a3a"
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]

  tags = {
    Name = var.instance_name
  }
}
