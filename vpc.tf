# create VPC and enble dns
#  create a vpc - region
# Below is to know the no.of availability zones(by default it will check from the .aws/config files.)

# data "aws_availability_zones" "available" {
#   state = "available"
# }


resource "aws_vpc" "vpc" {
  cidr_block           = "10.2.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name      = "stage-vpc-demo"
    Terraform = "True"
  }
}



# # CIDR
# # subnet--private,public,dataprivate
# #=====Public Subnet===================#
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(data.aws_availability_zones.available.names)
  cidr_block              = element(var.pub_cidr, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = "true"

  tags = {
    Name      = "stage-pub-subnet-demo-${count.index + 1}"
    Terraform = "True"
  }
}

# ======Pvt_Subnet===========

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(data.aws_availability_zones.available.names)
  cidr_block        = element(var.pvt_cidr, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  # map_public_ip_on_launch = "true"

  tags = {
    Name      = "stage-pvt-subnet-demo-${count.index + 1}"
    Terraform = "True"
  }
}

# ======data_Pvt_Subnet===========

resource "aws_subnet" "data" {
  vpc_id            = aws_vpc.vpc.id
  count             = length(data.aws_availability_zones.available.names)
  cidr_block        = element(var.data_pvt_cidr, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  # map_public_ip_on_launch = "true"

  tags = {
    Name      = "stage-data-subnet-demo-${count.index + 1}"
    Terraform = "True"
  }
}

# IGW

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "stage-igw-demo"
  }
  depends_on = [
    aws_vpc.vpc
  ]
}

# NAT-GW & assign EIP
# we are creating Public Natgw

# Create EIP
resource "aws_eip" "eip" {
  vpc = true

  tags = {
    Name = "stage-EIP"
  }
}

# Natgw

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "NATGW"
  }

  depends_on = [
    aws_eip.eip
  ]
}

# Route Table , subnet association & Route

# Route Tables

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Stage-Pub-RT"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "Stage-Pvt-RT"
  }
}

# Subnet Association/Route table association
# Pub subnets association

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

# Pvt subnet association

# NOTES:
# In below RT associations, in count variable lentgth we remains as public. 
# why bcoz both Public & Private also we have total 3 subnets. 
# If needed we can change to private also. thats our choice.
# But below both assosiations belongs to Private Route Table. So, RT id is same.


resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "data" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = element(aws_subnet.data[*].id, count.index)
  route_table_id = aws_route_table.private.id
}