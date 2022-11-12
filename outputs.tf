output "public_ip" {
  value = aws_instance.prometheus.public_ip
}
