#!/bin/bash

# this script upload .csv file into mysql database 
# first you need to create an empty database and a table in mysql, the column names in mysql table should be exactly same as column names in .csv file
# second create mysqlcred and specify in it  the username, password  and created database name in mysql server
# for now all values will be uploaded as string values , so you need to make all columns type  string
#  when calling the scripts you need to specify  table name in mysql and .csv file 
# example :  bash insert.sh  mysql_table_name  csv_file_name.csv


count=0
while IFS=, read -ra row_data; do
printf -v values '"%s",' "${row_data[@]}"
 if [[ $count -eq 0  ]]
    then
    ((count++))
    printf -v column_names "%s", "${row_data[@]}"  # creating column names array
    continue;
    fi
     echo "insert into $1 $(echo '('${column_names%,}')') VALUES  $(echo '('"${values%,}"')');"
     mysql --defaults-file=mysqlcred  -e  "insert into $1 $(echo '('"${column_names%,}"')') VALUES  $(echo '('"${values%,}"')');"
     ((count++))

 

done < $2

 
