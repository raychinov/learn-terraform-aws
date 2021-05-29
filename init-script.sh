#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl enable httpd
sudo systemctl start httpd
#echo "${file_content}!" > /var/www/html/index.html
#echo ${srv_index}
sudo echo "${efs_ip}:/ /var/www/html nfs4 defaults,_netdev 0 0" | sudo tee -a /etc/fstab
sleep 5
sudo mount -a
## use srv 0 to deploy
if [[ ${srv_index} -eq 0 ]]; then
  cd /tmp
  wget https://wordpress.org/latest.tar.gz
  tar -xzf latest.tar.gz
  cp wordpress/wp-config-sample.php wordpress/wp-config.php
  # edit it              ^
  #sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
  #cd /home/ec2-user
  sudo cp -r wordpress/* /var/www/html/
  sudo chown -R apache:apache /var/www/html/
  sudo chmod -R 755 /var/www/html/              
fi
sudo service httpd restart

