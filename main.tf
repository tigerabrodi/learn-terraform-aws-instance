terraform {

  cloud {
    organization = "tiger_projects"
    workspaces {
      name = "learn-tfc-aws"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.example_vpc.id
}

# Create a new network ACL
resource "aws_network_acl" "example_nacl" {
  vpc_id = aws_vpc.example_vpc.id

  tags = {
    Name = "example_nacl"
  }
}

# Add inbound rules to the NACL
resource "aws_network_acl_rule" "inbound_http" {
  network_acl_id = aws_network_acl.example_nacl.id
  rule_number    = 100
  rule_action    = "allow"
  egress         = false
  protocol       = "tcp"
  from_port      = 80
  to_port        = 80
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "inbound_ssh" {
  network_acl_id = aws_network_acl.example_nacl.id
  rule_number    = 200
  rule_action    = "allow"
  egress         = false
  protocol       = "tcp"
  from_port      = 22
  to_port        = 22
  cidr_block     = "0.0.0.0/0"
}

# Add outbound rule to the NACL
resource "aws_network_acl_rule" "outbound_all" {
  network_acl_id = aws_network_acl.example_nacl.id
  rule_number    = 300
  rule_action    = "allow"
  egress         = true
  protocol       = "-1"
  from_port      = 0
  to_port        = 0
  cidr_block     = "0.0.0.0/0"
}

# Associate the NACL with the subnet
resource "aws_network_acl_association" "example_nacl_association" {
  network_acl_id = aws_network_acl.example_nacl.id
  subnet_id      = aws_subnet.example_subnet.id
}



resource "aws_subnet" "example_subnet" {
  vpc_id            = aws_vpc.example_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  # ensures all instances launched in this subnet are automatically assigned a public IP address
  map_public_ip_on_launch = true
}

resource "aws_security_group" "app_server_sg" {
  name        = "app_server_sg"
  description = "Security group for the application server"
  vpc_id      = aws_vpc.example_vpc.id

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
  subnet_id              = aws_subnet.example_subnet.id
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]

  tags = {
    Name = var.instance_name
  }
}
