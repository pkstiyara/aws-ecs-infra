
#############################################################
#                              VPC
#############################################################

resource "aws_vpc" "main" {
  cidr_block       = "172.16.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "pollpapa-dev-vpc"
  }
}

########################################################################
#                        PUBLIC SUBNET - 1
########################################################################
resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.16.10.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-subnet-1"
  }
}


########################################################################
#                        PUBLIC SUBNET - 2
########################################################################
resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.16.20.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-subnet-2"
  }
}

########################################################################
#                       INTERNET GATEWAY
########################################################################

resource "aws_internet_gateway" "dev-igw" {
    vpc_id = aws_vpc.main.id

    tags ={
        Name = "pollpapa-internet-gateway"
    }
  
}


########################################################################
#                        ROUTE TABLE
########################################################################

resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.main.id
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = aws_internet_gateway.dev-igw.id 
    }
    
    tags = {
        Name = "Public-Route-Table"
    }
}

## Route Table Association 

resource "aws_route_table_association" "public-1"{
    subnet_id = aws_subnet.public-subnet-1.id
    route_table_id = aws_route_table.public-rt.id
}

# Route table association for 2nd Subnet

resource "aws_route_table_association" "public-2" {
  subnet_id = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public-rt.id
}

# # ********************************************************************************************************

# # Comment this out if not using the NAT GATEWAY

# ########################################################
# ##                  PRIVATE SUBNET AND NAT GATEWAY 
# ########################################################

# #########################################################
# #               ELASTIC IP
# ##########################################################
# resource "aws_eip" "nat-gateway-eip" {
#   vpc = true

#   tags = {
#     Name = "nat-gateway-eip"
#   }
# }

# #########################################################
# #               NAT GATEWAY
# ##########################################################

# resource "aws_nat_gateway" "nat-gateway" {
#   allocation_id = aws_eip.nat-gateway-eip.id
#   subnet_id     = aws_subnet.public-subnet-1.id

#   tags = {
#     Name = "nat-gateway"
#   }
# }

# ########################################################################
# #                        ROUTE TABLE FOR PRIVATE SUBNETS
# ########################################################################

# resource "aws_route_table" "private-rt" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "Private-Route-Table"
#   }
# }

# # Route table association for 1st Private Subnet

# resource "aws_route_table_association" "private-1"{
#     subnet_id = aws_subnet.private-subnet-1.id
#     route_table_id = aws_route_table.private-rt.id
# }

# # Route table association for 2nd Private Subnet

# resource "aws_route_table_association" "private-2" {
#   subnet_id = aws_subnet.private-subnet-2.id
#   route_table_id = aws_route_table.private-rt.id
# }

# # Route for private subnet traffic to use NAT gateway

# resource "aws_route" "private-subnets-to-nat-gateway" {
#   route_table_id = aws_route_table.private-rt.id
#   cidr_block     = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.nat-gateway.id
# }


# # Comment out above if not using the NAT GATEWAY
# #*******************************************************************************************


########################################################################
#                        PRIVATE SUBNET - 1
########################################################################

resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.16.1.0/24"


  tags = {
    Name = "Private-Subnet-1"
  }
}

########################################################################
#                        PRIVATE SUBNET - 2
########################################################################

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "172.16.2.0/24"


  tags = {
    Name = "Private-Subnet-2"
  }
}


########################################################################
#                        SECURITY GROUP
########################################################################

resource "aws_security_group" "dev-sg" {
    vpc_id = aws_vpc.main.id
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        // This means, all ip address are allowed to ssh ! 
        // Do not do it in the production. 
        // Put your office or home address in it!
        cidr_blocks = ["0.0.0.0/0"]
    }
    //If you do not add this rule, you can not reach the NGINX  
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "pollpapa-sg-dev"
    }
}

