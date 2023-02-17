
#############################################################
#                              VPC
#############################################################

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

########################################################################
#                        PUBLIC SUBNET
########################################################################
resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.26.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public-Subnet-1"
  }
}

########################################################################
#                       INTERNET GATEWAY
########################################################################

resource "aws_internet_gateway" "dev-igw" {
    vpc_id = aws_vpc.main.id

    tags ={
        Name = "Dev-Internet-Gateway"
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
    
    tags {
        Name = "Public-Route-Table"
    }
}

## Route Table Association 

resource "aws_route_table_association" "public-route-association"{
    subnet_id = aws_subnet.public-subnet.id
    route_table_id = aws_route_table.public-rt.id
}

########################################################################
#                        PRIVATE SUBNET
########################################################################

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.26.10.0/24"


  tags = {
    Name = "Private-Subnet-1"
  }
}


########################################################################
#                        SECURITY GROUP
########################################################################

resource "aws_security_group" "ssh-allowed" {
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
    tags {
        Name = "ssh-and-HTTP-allowed"
    }
}