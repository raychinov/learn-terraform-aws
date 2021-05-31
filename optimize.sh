#!/usr/bin/bash
echo START: $(date)
mysql -h ${db_host} -P ${db_port} -u ${db_user} -p${db_pass} < /usr/local/bin/select.sql
mysqlcheck -h ${db_host} -P ${db_port} -u ${db_user} -p${db_pass} -o ${db_name}
mysql -h ${db_host} -P ${db_port} -u ${db_user} -p${db_pass} < /usr/local/bin/select.sql
echo END
echo
