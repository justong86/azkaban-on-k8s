#!/bin/bash
#creat by zang.

funReplaceENV(){
    echo "path is :`pwd`"
    if [ -z $MYSQL_HOST ];then
        echo "Not Exists Environment variables:MYSQL_HOST"
        exit 1
    fi
    if [ -f /opt/azkaban/conf/azkaban-exe.properties ];then
        echo "Move exe configfile(azkaban.properties) to ./conf/"
        cp -f /opt/azkaban/conf/azkaban-exe.properties ${AZKABAN_EXE_HOME}/conf/azkaban.properties
    fi
    if [ -f /opt/azkaban/conf/azkaban-web.properties ];then
        echo "Move web configfile(azkaban.properties) to ./conf/"
        cp -f /opt/azkaban/conf/azkaban-web.properties ${AZKABAN_WEB_HOME}/conf/azkaban.properties
    fi
    ls -al conf/
    sed -i "s#mysql.host=MYSQL_HOST#mysql.host=${MYSQL_HOST}#g" ./conf/azkaban.properties
    sed -i "s#mysql.database=MYSQL_DB#mysql.database=${MYSQL_DB}#g" ./conf/azkaban.properties
    sed -i "s#mysql.user=MYSQL_USER_NAME#mysql.user=${MYSQL_USER_NAME}#g" ./conf/azkaban.properties
    sed -i "s#mysql.password=MYSQL_USER_PASSWORD#mysql.password=${MYSQL_USER_PASSWORD}#g" ./conf/azkaban.properties
}

funStartExe(){
    echo "start azkaban exe!"
    cd ${AZKABAN_EXE_HOME}
    funReplaceENV
    dash ./bin/internal/internal-start-executor.sh 2>&1 | tee -a logs/output.log
}

funStartWeb(){
    echo "start azkaban web!"
    cd ${AZKABAN_WEB_HOME}
    funReplaceENV
    dash ./bin/internal/internal-start-web.sh 2>&1 | tee -a logs/output.log
}

if [ "$1" = "exe" ]
then
    funStartExe
elif [ "$1" = "web" ]
then
    funStartWeb
elif [ "$1" = "all" ]
then
    funStartExe
    funStartWeb
else
    echo "args is 'web' or 'exe' or 'all' !! But your input is $1"
fi