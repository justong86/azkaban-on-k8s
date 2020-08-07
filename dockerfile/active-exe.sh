#!/bin/bash
# 定时监控日志，发现节点启动完成后，到数据库激活节点
while true;do
    status=$(grep 'Started Executor Server on' ${AZKABAN_EXE_HOME}/logs/azkaban-execserver.log |wc -l)
    if [ ${status} -gt 0 ];then 
        # mysql -u${MYSQL_USER_NAME} -p${MYSQL_USER_PASSWORD} -h${MYSQL_HOST} ${MYSQL_DB} -e "UPDATE executors SET active=1 WHERE host='`hostname -A`'"
        curl "http://`hostname -A|awk '$1=$1'`:12321/executor?action=activate"
        break
    fi
    sleep 5s
done