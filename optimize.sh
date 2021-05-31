#!/usr/bin/bash
echo START: $(date)
mysql -h ${db_host} -P ${db_port} -u ${db_user} -p${db_pass} < /usr/local/bin/select.sql
mysqlcheck -h ${db_host} -P ${db_port} -u ${db_user} -p${db_pass} -o ${db_name}
mysql -h ${db_host} -P ${db_port} -u ${db_user} -p${db_pass} < /usr/local/bin/select.sql
echo END $(date)

#SELECT table_name "Table Name", table_rows "Rows Count", round(((data_length + index_length)/1024/1024),2) "Table Size(MB)" FROM information_schema.TABLES WHERE table_schema = "${db_name}";
#SELECT TABLE_NAME AS `ALLTABLESNAME`, ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024) AS `TABLESIZEIN(MB)`
# FROM information_schema.TABLES WHERE TABLE_SCHEMA = "wp_db"
# ORDER BY (DATA_LENGTH + INDEX_LENGTH) ASC;
