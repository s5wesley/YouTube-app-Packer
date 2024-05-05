packer {
  required_plugins {
    amazon-ebs = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "wesley" {
  ami_name             = "wesley-master-jenkins"
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
    Name = "s5wesley-jenkins-master-ubuntu-20.04"
  }
}

build {
  name = "ubuntu-20.40-wesley-master-jenkins"
  sources = [
    "amazon-ebs.wesley"
  ]

  provisioner "file" {
    source      = "./jenkins-master.sh"
    destination = "/tmp/jenkins-master.sh"
  }

  provisioner "shell" {
    inline = [
      "sudo chmod +x /tmp/jenkins-master.sh",
      "sudo bash /tmp/jenkins-master.sh"
    ]
  }
}
