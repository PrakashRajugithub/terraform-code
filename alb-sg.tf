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

resource "aws_security_group" "alb" {
  name        = "allow End User"
  description = "Allow Enduser inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "End Users"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   
  }

#    ingress {
#     description = "Admin Users"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
   
#   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name      = "stage-alb-sg"
    Terraform = "True"
  }
}