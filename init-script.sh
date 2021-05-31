#!/bin/bash
sudo yum update -y
sudo yum install httpd mysql php -y
sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
sudo systemctl enable httpd
sudo systemctl start httpd
sudo echo "${efs_ip}:/ /var/www/html nfs4 defaults,_netdev 0 0" | sudo tee -a /etc/fstab
sleep 10
sudo mount -a
## use srv 0 to deploy
if [[ ${srv_index} -eq 0 ]]; then
  cd /tmp
  wget https://wordpress.org/wordpress-5.7.tar.gz
  tar -xzf wordpress-5.7.tar.gz
  #cp wordpress/wp-config-sample.php wordpress/wp-config.php
  #sed -e "s/localhost/"${mysqlhost}"/" -e "s/database_name_here/"${mysqldb}"/" -e "s/username_here/"${mysqluser}"/" -e "s/password_here/"${mysqlpass}"/" wp-config-sample.php > wp-config.php
  sudo cp -r wordpress/* /var/www/html/
#  sudo chown -R apache:apache /var/www/html/
#  sudo chmod -R 755 /var/www/html/
  sudo service httpd restart
#
  # setup wp-cli
  curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
  chmod 777 /tmp/wp-cli.phar
  cd /var/www/html
  sudo /tmp/wp-cli.phar config create --dbhost=${mysqlhost} --dbname=${mysqldb} --dbuser=${mysqluser} --dbpass=${mysqlpass}
  sleep 10
  sudo /tmp/wp-cli.phar core install --url=${siteurl} --title=Blue --admin_user=wp_admin --admin_email=wp_admin@blue.co | sudo tee wp_admin
  sleep 10
  sudo /tmp/wp-cli.phar post update 1 --post_title='Linux Namespaces' --post_content="${wp_post}"

#
#  /tmp/wp-cli.phar site create --slug=Blue
#  sleep 20
#  /tmp/wp-cli.phar user create bob bob@blue.co --role=administrator
#  sleep 20
#  sleep 20
#
## Optimize cron
 echo "SELECT table_name 'Table Name', table_rows 'Rows Count', round(((data_length + index_length)/1024/1024),2) 'Table Size(MB)' FROM information_schema.TABLES WHERE table_schema = ${mysqldb};" >/usr/local/bin/select.sql


  echo "${optimize_script}">>/usr/local/bin/optimize.sh
#  ## 02:00 on Sunday.
  echo "0 2 * * 7 /bin/bash /usr/local/bin/optimize.sh >>/var/log/optimize.log" >>/etc/crontab
  echo "* * * * * /usr/bin/echo kuku >>/var/log/optimize1.log" >>/etc/crontab
#
 ## get -O /tmp/wp.keys https://api.wordpress.org/secret-key/1.1/salt/
 # Butcher our wp-config.php file
# sed -i '/#@-/r /tmp/wp.keys' wp-config.php
# sed -i "/#@+/,/#@-/d" wp-config.php

 #wget --post-data "weblog_title=$wptitle&user_name=$wpuser&admin_password=$wppass&admin_password2=$wppass&admin_email=$wpemail" http://${siteurl}/wp-admin/install.php?step=2
 #wget --post-data "weblog_title='Namespaces'&user_name=wpuser&admin_password=46?USUALLY?finished?PERFECT?49&admin_password2=46?USUALLY?finished?PERFECT?49&admin_email=wpemail@lala.co" http://${siteurl}/wp-admin/install.php?step=2
 #echo "weblog_title='Nmespaces'&user_name=wpuser&admin_password=46?USUALLY?finished?PERFECT?49&admin_password2=46?USUALLY?finished?PERFECT?49&admin_email=wpemail@lala.co http://${siteurl}/wp-admin/install.php?step=2">>/tmp/wp.log
 #sudo service httpd restart
  sudo chown -R apache:apache /var/www/html/
  sudo chmod -R 755 /var/www/html/

fi
sudo service httpd restart

