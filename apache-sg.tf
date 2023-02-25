# The below one  is for to get MY IP Dynamically.
# data "http" "myip" {
#   url = "http://ipv4.icanhazip.com"
# }


# =============================
# The below data source code is to call VPC is when wee dont have vpc in current folder.
# By using below code we are filtering the VPC Tag Name. 
# So that Terraform will Filter in AWS and choose Correct Tag name and then it will picks the VPV ID.
# Finally we'll call the below Data Source in Resource "vpc_id" as 'vpc_id      = data.aws_vpc.stage.id'

# data "aws_vpc" "stage" {
#   filter {
#     name   = "tag:Name"
#     values = ["stage-vpc-demo"]
#   }
# }
# ============================

resource "aws_security_group" "apache" {
  name        = "allow bastion"
  description = "Allow bastion inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Bastion-Apache"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion.id]
    # The above line is to get IP. "chomp" used for 'if there is any spacs in between the line it will delete the spaces'
  }

ingress {
    description = "Alb-Apache"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [aws_security_group.alb.id]
    
  }
  egress { 
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name      = "stage-apache-sg"
    Terraform = "True"
  }
}

resource "aws_instance" "apache" {
  ami           = "ami-0753e0e42b20e96e3"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.private[0].id
  vpc_security_group_ids = [aws_security_group.apache.id]
  
  tags = {
    Name = "stage-apache"
    Terraform ="True"
  }
}