
# Elastic IP for NAT gateway
resource "aws_eip" "nj_eip" {
  depends_on = [aws_internet_gateway.nj_gw]
  domain     = "vpc"
  tags = {
    Name = "nj_EIP_for_NAT"
  }
}

# NAT gateway for private subnets 
# (for the private subnet to access internet - eg. ec2 instances downloading softwares from internet)
resource "aws_nat_gateway" "nj_nat_for_private_subnet" {
  allocation_id = aws_eip.nj_eip.id
  subnet_id     = aws_subnet.nj_subnet_1.id # nat should be in public subnet

  tags = {
    Name = "NJ NAT for private subnet"
  }

  depends_on = [aws_internet_gateway.nj_gw]
}

# route table - connecting to NAT
resource "aws_route_table" "nj_rt_private" {
  vpc_id = aws_vpc.nj_main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nj_nat_for_private_subnet.id
  }
}

# associate the route table with private subnet
resource "aws_route_table_association" "nj_rta3" {
  subnet_id      = aws_subnet.nj_subnet_2.id
  route_table_id = aws_route_table.nj_rt_private.id
}
