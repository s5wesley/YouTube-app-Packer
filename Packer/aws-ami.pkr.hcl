packer {
  required_plugins {
    amazon-ebs = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "wesley" {
  ami_name             = "s5wesley"
  instance_type        = "t2.medium"
  region               = "us-east-1"
  source_ami_filter {
    filters = {
      name                 = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      virtualization-type  = "hvm"
      root-device-type     = "ebs"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username         = "ubuntu"
  tags = {
    Name = "s5wesley-ubuntu-20.04"
  }
}

build {
  name = "ubuntu-20.40-wesley"
  sources = [
    "amazon-ebs.wesley"
  ]

  provisioner "file" {
    source      = "./ec2_packages.sh"
    destination = "/tmp/ec2_packages.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo chmod +x /tmp/ec2_packages.sh",
      "sudo bash /tmp/ec2_packages.sh"
    ]
  }
}
