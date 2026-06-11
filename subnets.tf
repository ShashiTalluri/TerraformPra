resource "aws_subnet" "pub_01" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags = {
    Name        = "pub-01"
    Environment = var.environment
  }
}

resource "aws_subnet" "pub_02" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}b"
  tags = {
    Name        = "pub-02"
    Environment = var.environment
  }
}

resource "aws_subnet" "app_01" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name        = "app-01"
    Environment = var.environment
  }
}

resource "aws_subnet" "app_02" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name        = "app-02"
    Environment = var.environment
  }
}
