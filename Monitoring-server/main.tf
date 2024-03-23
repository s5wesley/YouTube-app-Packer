##Create EC2 Instance and Setup Prometheus & Grafana
resource "aws_instance" "web" {
  ami                    = "ami-07d9b9ddc6cd8dd30" #change ami id for different region
  instance_type          = "t2.medium"
  key_name               = "terraform-aws" #change key name as per your setup
  vpc_security_group_ids = [aws_security_group.Monitoring2-Server-SG.id]
  user_data              = templatefile("./install.sh", {})

  tags = {
    Name = "Monitoring-Server"
  }

  root_block_device {
    volume_size = 20
  }
}

// Create the Elastic IP "WESLEY-CICD_eip"
resource "aws_eip" "WESLEY-CICD_eip" {
  instance = aws_instance.web.id
  vpc      = true

  tags = {
  Name = "WESLEY-CICD_eip" }
}


resource "aws_security_group" "Monitoring2-Server-SG" {
  name        = "Monitoring-Server-SG"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 9090, 9100, 3000] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Monitoring2-Server-SG"
  }
}