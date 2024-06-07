resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.cidr_block, 8, 1)
}

output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.main.id
}

