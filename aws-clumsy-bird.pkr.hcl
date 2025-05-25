packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1"
    }
  }
}

variable "region" {
  type    = string
  default = "us-east-1"
}

source "amazon-ebs" "ubuntu_clumsy" {
  region                  = var.region
  instance_type           = "t2.micro"
  ami_name                = "clumsy-bird-ubuntu-{{timestamp}}"
  ami_regions             = [var.region]
  ssh_username            = "ubuntu"
  tags = {
    Name = "ClumsyBirdAMI"
  }

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] # Canonical
  }
}

build {
  sources = ["source.amazon-ebs.ubuntu_clumsy"]

  provisioner "file" {
    source      = "launch.sh"
    destination = "/tmp/launch.sh"
  }

  provisioner "file" {
    source      = "clumsy-bird.service"
    destination = "/etc/systemd/system/clumsy-bird.service"
  }

  provisioner "shell" {
    inline = [
      "chmod +x /tmp/launch.sh",
      "mv /tmp/launch.sh /usr/local/bin/launch.sh",
      "systemctl daemon-reexec",
      "systemctl enable clumsy-bird",
      "systemctl start clumsy-bird"
    ]
  }

  post-processor "manifest" {}
}
