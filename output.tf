

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public-subnet-1" {
  value = aws_subnet.public-subnet-1
}

output "public-subnet-2" {
  value = aws_subnet.public-subnet-2

}

output "private-subnet-1" {
  value = aws_subnet.private-subnet-1  
}

output "private-subnet-2" {
  value = aws_subnet.private-subnet-2
  
}

output "igw_id" {
  value = aws_internet_gateway.dev-igw.id
}