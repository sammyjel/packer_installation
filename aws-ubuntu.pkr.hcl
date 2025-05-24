packer {
  required_plugins {
    amazon = {

      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"

      source  = "github.com/hashicorp/amazon"
      version = "~> 1"

    }
  }
}

source "amazon-ebs" "ubuntu" {

  ami_name      = "learn-packer-linux-aws-ubuntutest"
  instance_type = "t2.micro"
  region        = "ap-southeast-2"

  ami_name      = "packer-ubuntu-aws-{{timestamp}}"
  instance_type = "t3.micro"
  region        = "us-east-1"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "learn-packer"


build {

  sources = [
    "source.amazon-ebs.ubuntu"
  ]
}

