#!/bin/bash
exec > >(tee -a "/tmp/init.log") 2>&1
#sudo yum update -y
sudo yum install httpd mysql -y
sudo amazon-linux-extras install -y php7.2
#sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo systemctl enable httpd
sudo systemctl start httpd
sudo echo "${efs_ip}:/ /var/www/html nfs4 defaults,_netdev 0 0" | sudo tee -a /etc/fstab
#sleep 10
sudo mount -a
touch /tmp/srv-${srv_index}
## use srv 0 to deploy
if [[ ${srv_index} -eq 0 ]]; then
  cd /tmp
  wget https://wordpress.org/wordpress-5.7.tar.gz
  tar -xzf wordpress-5.7.tar.gz
  sudo cp -r wordpress/* /var/www/html/
#  sudo chown -R apache:apache /var/www/html/
#  sudo chmod -R 755 /var/www/html/
  sudo service httpd restart

  # wp-cli
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod 777 /tmp/wp-cli.phar
  cd /var/www/html
  sudo /tmp/wp-cli.phar config create --dbhost=${mysqlhost} --dbname=${mysqldb} --dbuser=${mysqluser} --dbpass=${mysqlpass}
  sudo /tmp/wp-cli.phar core install --url=${siteurl} --title=Blue --admin_user=wp_admin --admin_email=wp_admin@blue.co
  sudo /tmp/wp-cli.phar post update 1 --post_title='Linux Namespaces' --post_content="${wp_post}"

## Optimize cron
  echo "SELECT table_name 'Table Name', table_rows 'Rows Count', round(((data_length + index_length)/1024/1024),2) 'Table Size(MB)' FROM information_schema.TABLES WHERE table_schema = \"${mysqldb}\";" >/usr/local/bin/select.sql

  echo "${optimize_script}">>/usr/local/bin/optimize.sh
  touch /var/log/optimize.log
  chown ec2-user  /var/log/optimize.log
  # 02:00 on Sunday
  echo "0 2 * * 7 ec2-user /bin/bash /usr/local/bin/optimize.sh &>>/var/log/optimize.log" >>/etc/crontab

  sudo chown -R apache:apache /var/www/html/
  sudo chmod -R 755 /var/www/html/
fi
sudo service httpd restart

