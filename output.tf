

output "vpc_id" {
  value = aws_vpc.main.id
}

output "public-subnet-1" {
  value = aws_subnet.public-subnet-1.id
}

output "public-subnet-2" {
  value = aws_subnet.public-subnet-2.id

}

output "private-subnet-1" {
  value = aws_subnet.private-subnet-1.id  
}

output "private-subnet-2" {
  value = aws_subnet.private-subnet-2.id
  
}

output "igw_id" {
  value = aws_internet_gateway.dev-igw.id
}