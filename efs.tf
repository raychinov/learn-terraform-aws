# Creating EFS file system
resource "aws_efs_file_system" "efs" {
  creation_token = "wp-store"
  encrypted = true
  tags = {
    Name = "WP-EFS-Store"
  }
}

resource "aws_efs_mount_target" "mount" {
#  count = var.enable_blue_env ? var.blue_instance_count : 0
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = module.vpc.private_subnets[0]
  security_groups = [module.app_security_group.this_security_group_id]
}

#resource "null_resource" "configure_nfs" {
##  count = var.enable_blue_env ? var.blue_instance_count : 0
#  depends_on = [aws_efs_mount_target.mount]
#  connection {
#    type     = "ssh"
#    user     = "ec2-user"
#    private_key = tls_private_key.bluekey.private_key_pem
#    host     = aws_instance.blue[0].public_ip
#  }
#  provisioner "remote-exec" {
#    inline = [
#      "sudo apt-get install httpd php git -y -q ",
#      "sudo systemctl start httpd",
#      "sudo systemctl enable httpd",
##      # "sudo yum -y install nfs-utils",     # Amazon ami has pre installed nfs utils
#      "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_mount_target.mount.ip_address}:/  /var/www/html",
##      "sudo echo \"${aws_efs_mount_target.mount.ip_address}:/ /var/www/html nfs4 defaults,_netdev 0 0\" | sudo tee -a /etc/fstab ",
#      "sudo chmod go+rw /var/www/html",
#      "sudo git clone https://github.com/Apeksh742/EC2_instance_with_terraform.git /var/www/html",
#    ]
#  }
#}

