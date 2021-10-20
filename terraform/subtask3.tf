# security group for bastion

resource "aws_security_group" "bastion" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
      description      = "TLS from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  tags = {
    Name = "security-group-bastion"
  }
}

# security group for jenkins

resource "aws_security_group" "jenkins" {
  name        = "allow_tcp"
  description = "Allow Tcp inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
      description      = "TLS from VPC"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
      description      = "TLS from VPC"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  tags = {
    Name = "security-group-jenkins"
  }
}

# security group for private 

resource "aws_security_group" "private" {
  name        = "allow_tcpd"
  description = "Allow Tcpd inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "tcp"
      cidr_blocks      = ["10.0.4.0/24"]
  }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }

  tags = {
    Name = "security-group-private"
  }
}

