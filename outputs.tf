output "lb_dns_name" {
  value = aws_lb.app.dns_name
}

output "ec2_public_ip" {
  value = aws_instance.blue[*].public_ip
}

resource "local_file" "private_key" {
  content  = tls_private_key.bluekey.private_key_pem
  filename = "private_key.pem"
}

