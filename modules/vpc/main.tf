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
