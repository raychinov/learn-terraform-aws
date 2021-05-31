output "web_access" {
  value = "http://${aws_lb.app.dns_name}"
}

resource "local_file" "private_key" {
  sensitive_content = tls_private_key.bluekey.private_key_pem
  filename = "private_key.pem"
  file_permission = "0600"
}

output "ssh_access" {
  value = "Credentials for SSH and DB access can be found in ${local_file.credentials.filename}"
}

resource "local_file" "credentials" {
  sensitive_content = <<_EOF
mysql -h ${aws_db_instance.mysql.address} -P ${aws_db_instance.mysql.port} -u ${aws_db_instance.mysql.username} -p${random_password.db_pass.result}
ssh ec2-user@${aws_instance.blue[0].public_ip} -i ${local_file.private_key.filename}

_EOF
  filename = "credentials"
}

### Debug
#resource "local_file" "init" {
#  content = templatefile("${path.module}/init-script.sh", {
#    efs_ip = "${aws_efs_mount_target.mount.ip_address}"
#    srv_index = "0"
#    mysqlhost = "${aws_db_instance.mysql.address}"
#    mysqldb = "${aws_db_instance.mysql.name}"
#    mysqluser = "${aws_db_instance.mysql.username}"
#    mysqlpass = "${aws_db_instance.mysql.password}"
#    siteurl = "${aws_lb.app.dns_name}"
#    wp_post = file("wp_post.txt")
#    optimize_script = data.template_file.optimize.rendered
#  })
# filename = "init.sh"
#}

#output "ec2_public_ip" {
#  value = aws_instance.blue[*].public_ip
#}

