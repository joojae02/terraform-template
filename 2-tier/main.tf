

# 삭제 예정

# # 인터넷 게이트웨이 생성
# resource "aws_internet_gateway" "default" {
#   vpc_id = aws_vpc.default.id
# }

# # 기본 라우팅 테이블에 VPC 인터넷 액세스 권한 부여
# resource "aws_route" "internet_access" {
#   route_table_id         = aws_vpc.default.main_route_table_id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.default.id
# }

# # 인스턴스 생성할 서브넷 생성
# resource "aws_subnet" "default" {
#   vpc_id                  = aws_vpc.default.id
#   cidr_block              = "10.0.1.0/24"
#   map_public_ip_on_launch = true
# }

# # ELB용 보안 그룹
# resource "aws_security_group" "elb" {
#   name        = "terraform_example_elb"
#   description = "Used in the terraform"
#   vpc_id      = aws_vpc.default.id

#   # HTTP 전체 허용
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # 아웃바운드 인터넷 액세스
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # 액세스할 기본 보안 그룹
# # SSH 및 HTTP를 통한 인스턴스
# resource "aws_security_group" "default" {
#   name        = "terraform_example"
#   description = "Used in the terraform"
#   vpc_id      = aws_vpc.default.id

#   # SSH 접근 모두 허용
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # HTTP vpc로부터 접근
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["10.0.0.0/16"]
#   }

#   # 아웃바운드
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # elb 생성
# resource "aws_elb" "web" {
#   name = "terraform-example-elb"

#   subnets         = [aws_subnet.default.id]
#   security_groups = [aws_security_group.elb.id]
#   instances       = [aws_instance.web.id]

#   listener {
#     instance_port     = 80
#     instance_protocol = "http"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }
# }

# resource "aws_key_pair" "auth" {
#   key_name   = var.key_name
#   public_key = file(var.public_key_path)
# }

# resource "aws_instance" "web" {
#   # The connection block tells our provisioner how to
#   # communicate with the resource (instance)
#   connection {
#     type = "ssh"
#     # The default username for our AMI
#     user = "ubuntu"
#     host = self.public_ip
#     # The connection will use the local SSH agent for authentication.
#   }

#   instance_type = "t2.micro"

# 	# 기본 ami
#   ami = var.aws_amis[var.aws_region]

# 	# 위에서 만든 ssh keypair
#   key_name = aws_key_pair.auth.id

#   # Our Security group to allow HTTP and SSH access
#   vpc_security_group_ids = [aws_security_group.default.id]

#   # We're going to launch into the same subnet as our ELB. In a production
#   # environment it's more common to have a separate private subnet for
#   # backend instances.
#   subnet_id = aws_subnet.default.id

#   # We run a remote provisioner on the instance after creating it.
#   # In this case, we just install nginx and start it. By default,
#   # this should be on port 80
#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt-get -y update",
#       "sudo apt-get -y install nginx",
#       "sudo service nginx start",
#     ]
#   }
# }