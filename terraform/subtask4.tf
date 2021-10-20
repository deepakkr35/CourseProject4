
# Creating Key pair for EC2 instance
resource "aws_key_pair" "assignment-key" {
  key_name   = "assignment-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDS+kA3GLa/FJJHZ/5Q91MHvSZDiikfknrDNelt9VJub2UhKFjp+HGaqnbG/9TC2XUOvLM4y8lbVvuhwSGlsvV4PULXbkiE4wtqymu8Si7iOu6DPi2QZem25MKL7gMhbIJ/LAqY/KwaSzQalHy3uXnHYv7u6ylLUXxQugnYWcQI4MrgNccycF9LGjARlqgFSR+6AxP1WY4U85E6fCUWd5boWSGf133ps92wQRxwp7d3itPck7MxMrDIRPlD2grIPc8AtxXddNvf1vIh21cdLNqo/DT/ztVAdD8NNQEJ+qJhUh/7FXR2h2lI0ZRqNDFvk99UDmKV2isXGMFi7xbG/3zb ec2-user@ip-172-31-29-31.ec2.internal"
}

# Creating EC2 instances 
resource "aws_instance" "bastion" {
  ami                    = "ami-09e67e426f25ce0d7"
  instance_type          = "t2.micro"
  key_name               = "assignment-key"
  subnet_id              = "${aws_subnet.public-subnet-1.id}" 
  security_groups       = ["${aws_security_group.bastion.id}"]
  
  tags = {
    Name = "assignment-bastion-ec2"
  }
}

# creating jenkins EC2 instance
resource "aws_instance" "jenkins-instance" {
  ami                    = "ami-09e67e426f25ce0d7"
  instance_type          = "t2.micro"   
  subnet_id              = "${aws_subnet.private-subnet-1.id}"
  security_groups        = ["${aws_security_group.jenkins.id}"]
  
  tags = {
    Name = "assignment-jenkins-ec2"
  }
}

# creating private EC2 instance
resource "aws_instance" "app" {
  ami                    = "ami-09e67e426f25ce0d7"
  instance_type          = "t2.micro"   
  subnet_id              = "${aws_subnet.private-subnet-2.id}"
  security_groups        = ["${aws_security_group.private.id}"]
  tags = {
    Name = "assignment-app-ec2"
  }
}

