data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["137112412989"]
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*x86_64*"]
  }
}

resource "aws_security_group" "prometheus_security_group" {
  name        = "prometheus_security_group"
  description = "Permite SSH e HTTP na instancia EC2"

  ingress {
    description = "SSH to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP to EC2"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "prometheus" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.id
  vpc_security_group_ids = [aws_security_group.prometheus_security_group.id]

  key_name = "deployer"

  tags = {
    Name        = var.name
    Enviroment  = var.env
    Provisioner = "Terraform"
    Repository  = var.repository
  }

  provisioner "local-exec" {
    command = <<EOF
      sleep 120; \
      ssh-keyscan -H '${self.public_ip}' >> ~/.ssh/known_hosts && \
      ansible-playbook --private-key='${var.key_pem}' -i ec2-user@'${self.public_ip}', ./playbooks/docker-playbook.yml && \
      ansible-playbook --private-key='${var.key_pem}' -i ec2-user@'${self.public_ip}', ./playbooks/prometheus-playbook.yml
    EOF
  }
}
