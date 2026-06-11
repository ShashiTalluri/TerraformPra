output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block of the created VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the created public subnets"
  value       = [aws_subnet.pub_01.id, aws_subnet.pub_02.id]
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of the created public subnets"
  value       = [aws_subnet.pub_01.cidr_block, aws_subnet.pub_02.cidr_block]
}

output "app_subnet_ids" {
  description = "IDs of the created application subnets"
  value       = [aws_subnet.app_01.id, aws_subnet.app_02.id]
}

output "app_subnet_cidrs" {
  description = "CIDR blocks of the created application subnets"
  value       = [aws_subnet.app_01.cidr_block, aws_subnet.app_02.cidr_block]
}

output "internet_gateway_id" {
  description = "ID of the created Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_id" {
  description = "ID of the created NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "nat_gateway_eip" {
  description = "Elastic IP of the NAT Gateway"
  value       = aws_eip.nat.public_ip
}

output "aws_instance" {
  value = aws_instance.bastion.ami
}