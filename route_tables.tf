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

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name        = "nat-eip"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pub_01.id

  tags = {
    Name        = "nat-gateway"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = {
    Name        = "private-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "app_01" {
  subnet_id      = aws_subnet.app_01.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "app_02" {
  subnet_id      = aws_subnet.app_02.id
  route_table_id = aws_route_table.private.id
}
