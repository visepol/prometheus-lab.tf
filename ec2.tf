data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["137112412989"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*x86_64*"]
  }
}

resource "aws_instance" "prometheus" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.id

  user_data = <<-EOL
    #!/bin/bash
    yum update -y
    yum install docker -y
    usermod -a -G docker ec2-user
    newgrp docker
    systemctl enable docker.service
    systemctl start docker.service

    docker run \
      -d \
      -p 9090:9090 \
      --name prometheus \
      --restart=unless-stopped \
      prom/prometheus
  EOL
  tags = {
    Name        = var.name
    Enviroment  = var.env
    Provisioner = "Terraform"
    Repository  = var.repository
  }
}
