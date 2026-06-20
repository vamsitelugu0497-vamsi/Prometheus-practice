output "public_ip" {
  value = aws_instance.prometheus_server.public_ip
}

output "instance_id" {
  value = aws_instance.prometheus_server.id
}
