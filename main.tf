
#############################################################
#                              VPC
#############################################################

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

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

  tags = {
    Name = "Public-Subnet-1"
  }
}


########################################################################
#                        PRIVATE SUBNET
########################################################################

resource "aws_subnet" "private-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.26.1.0/24"

  tags = {
    Name = "Private-Subnet-1"
  }
}