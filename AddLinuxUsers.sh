#!/bin/bash


# this script creates users on linux system from csv file,then output the users, passwords, and their emails in another csv file
# it assumes that first column in csv is their first name , and the third column is their emails

#you should pass the csv file contains the users data as argument  with script


echo username,password,email > server_users.csv  # creating the output csv file
count=0
while IFS=,  read -ra row_data; do   # row records will be saved in an array called row_data
    if [ $count -eq 0  ]   # discard  thefirst line as it contains column names not actual data
      then
        ((count++));
        continue;
    fi

 username=iti-${row_data[0]}${RANDOM}       # creates randome username contains 'iti' as prefix + their firstname + random number
 while true; do
 cut -d: -f1 /etc/passwd | grep $username   # check if the username already exists on system

 if [  $? -eq 0 ] ; then
   username=iti${row_data[0]}${RANDOM}        # creates new username by using the random number again
 else
    echo "username : $username  is unique "
    break      			            # if the username doesn't exist, exit the loop
 fi
 done


 useradd   $username                         # creating new user


 password=$(openssl rand -base64 8)

 echo  $password | passwd --stdin $username  # setting the user's password
 chage -d 0 $username
 echo  $username,$password,${row_data[2]},$SERVER_IP >> server_users.csv  # outputing the username and password in csv file
 

done < $1
