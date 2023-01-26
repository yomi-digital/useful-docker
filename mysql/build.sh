#!/bin/bash

if [[ "$@" =~ "-rebuild" ]]
then
    echo "Pulling mysql-server"
    docker pull mysql/mysql-server:latest
    docker run --restart=on-failure -d --name=mysql_db -dit -p 3306:3306 mysql/mysql-server:latest
else
    docker ps | grep 'mysql_db' &> /dev/null
    if [ $? == 0 ]; then
        echo "Database docker exists yet, running istance."
        docker start mysql_db
    else
        echo "Running MysqlDB."
        docker run --restart=on-failure -d --name=mysql_db -dit -e MYSQL_ROOT_HOST=% -p 3306:3306 mysql/mysql-server:latest
        sleep 15
        docker logs mysql_db 2>&1 | grep GENERATED
        docker exec -it mysql_db mysql -uroot -p
        # THEN ENTER:
        # ALTER USER 'root'@'localhost' IDENTIFIED BY '<REPLACE_WITH_YOUR_PASSWORD_HERE>';
        # ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '<REPLACE_WITH_YOUR_PASSWORD_HERE>';
        # ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY '<REPLACE_WITH_YOUR_PASSWORD_HERE>';
        # CREATE DATABASE defaultdb;
        # YOUR DATABASE IS READY!
    fi
fi