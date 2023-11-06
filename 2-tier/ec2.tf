resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "ec2_1" {
	connection {
		type = "ssh"
		# The default username for our AMI
		user = "ubuntu"
		host = self.public_ip
		# The connection will use the local SSH agent for authentication.
	}

	ami                     = var.ec2_instance_ami
	instance_type           = var.ec2_instance_type
	availability_zone       = var.az1
	subnet_id               = aws_subnet.public_subnet1.id
	vpc_security_group_ids  = [aws_security_group.webserver_sg.id] 
	
	key_name = aws_key_pair.auth.id

   # user_data               = <<EOF
   #     #!/bin/bash
   #     yum update -y
   #     yum install -y httpd
   #     systemctl start httpd
   #     systemctl enable httpd
   #     EC2AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
   #     echo '<center><h1>This Amazon EC2 instance is located in Availability Zone:AZID </h1></center>' > /var/www/html/index.txt
   #     sed"s/AZID/$EC2AZ/" /var/www/html/index.txt > /var/www/html/index.html
   #     EOF
   user_data = <<-EOF
     #!/bin/bash
     sudo apt-get -y update
     sudo apt-get -y install nginx
     sudo service nginx start
   EOF
	 
   tags = {
      name = "ec2_1"
  }
}

# 2nd ec2 instance on public subnet 2
resource "aws_instance" "ec2_2" {
  connection {
		type = "ssh"
		# The default username for our AMI
		user = "ubuntu"
		host = self.public_ip
		# The connection will use the local SSH agent for authentication.
	}

  ami                     = var.ec2_instance_ami
  instance_type           = var.ec2_instance_type
  availability_zone       = var.az2
  subnet_id               = aws_subnet.public_subnet2.id
	vpc_security_group_ids  = [aws_security_group.webserver_sg.id] 

	key_name = aws_key_pair.auth.id

#   user_data               = <<EOF
#        #!/bin/bash
#        sudo apt-get -y update
#        sudo apt-get -y install httpd
#        systemctl start httpd
#        systemctl enable httpd
#        EC2AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)
#        echo '<center><h1>This Amazon EC2 instance is located in Availability Zone:AZID </h1></center>' > /var/www/html/index.txt
#        sed"s/AZID/$EC2AZ/" /var/www/html/index.txt > /var/www/html/index.html
#        EOF 
	user_data = <<-EOF
		#!/bin/bash
		sudo apt-get -y update
		sudo apt-get -y install nginx
		sudo service nginx start
	EOF

  tags = {
     name = "ec2_2"
  }
}