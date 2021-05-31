output "lb_dns_name" {
  value = aws_lb.app.dns_name
}

output "ec2_public_ip" {
  value = aws_instance.blue[*].public_ip
}

resource "local_file" "private_key" {
  sensitive_content = tls_private_key.bluekey.private_key_pem
  filename = "private_key.pem"
  file_permission = "0600"
}

resource "local_file" "credentials" {
  sensitive_content = <<_EOF
mysql -h ${aws_db_instance.mysql.address} -P ${aws_db_instance.mysql.port} -u ${aws_db_instance.mysql.username} -p${random_password.db_pass.result}
ssh ec2-user@${aws_instance.blue[0].public_ip} -i ${local_file.private_key.filename}

_EOF
  filename = "credentials"
}
