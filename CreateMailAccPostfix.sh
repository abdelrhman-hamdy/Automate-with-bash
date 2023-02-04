#!/bin/bash
read -p " Mail's Username : " username

read -p " Mail's Password : " password


useradd -s /sbin/nologin $username

echo  $password | passwd --stdin $username

mkdir /home/$username/Maildir
chown $username:$username /home/$username/Maildir/


chmod u+rwx /home/$username/Maildir/
=======
chmod a+rwx /home/$username/Maildir/



