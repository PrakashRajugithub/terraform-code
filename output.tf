data "aws_availability_zones" "available" {
  state = "available"
}

output "zones" {
  value = data.aws_availability_zones.available.names
}

output "vpcid" {
  value = aws_vpc.vpc.id
}

output "igwid" {
  value = aws_internet_gateway.igw.id
  # value1 = aws_internet_gateway.igw.arn

}

# To get Eip id 
output "eipid" {
  value = aws_eip.eip.id
}

# To get Eip Public IP
output "public_ip" {
  # description = "Contains the public IP address"
  value = aws_eip.eip.public_ip
}