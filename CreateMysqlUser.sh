#!/bin/bash 


which database , table , connect local or remote
read -p 'Which databse will user access , if the user has full permission on all dbs, Enter * : ' db
read -p 'Which table will  user access , if the user has full permission on all tables, Enter * : ' table
read -p 'Enter Username : ' user
read -p 'Enter password : ' pass
read -p 'Will user access mysql server remotely (y/n)? ' access_remotely 
read -p ' what permissions can the user do , you should tpye permissions separated by comma, or incase of full permission type "all" : ' perms

mysql --defaults-file=mysqlcred -e "grant $perms on $db.$table to '$user'@'localhost' identified by '$pass'; "

if [[ $access_remotely == 'y'  ]]
then
     mysql --defaults-file=mysqlcred -e "grant $perms on $db.$table to '$user'@'%' identified by '$pass'; "
     mysql --defaults-file=mysqlcred -e "flush privileges;"       
fi

