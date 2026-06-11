resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "example-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "pub_01" {
  subnet_id      = aws_subnet.pub_01.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "pub_02" {
  subnet_id      = aws_subnet.pub_02.id
  route_table_id = aws_route_table.public.id
}
