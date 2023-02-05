#!/bin/bash

# you can use the script like this :  ./test.sh  mail.jana.com jana.com "192.168.1.0\/24"


function EditCongFile(){
sed -i -e  "s/#$1 = .*/$1 = $2/" $3
}

function CommentLine(){
sed  -i -e "/^$1/ c#$1" $2

}

function UnCommentLine(){
sed -i -e  "/^#$1/ c$1" $2

}
conf_file=/etc/postfix/main.cf

if [ "$(rpmquery postfix)" = "package postfix is not installed" ];then yum install postfix -y ;else echo " Postfix is installed"; fi

EditCongFile myhostname $1 $conf_file

EditCongFile mydomain   $2  $conf_file

EditCongFile myorigin "\$mydomain" $conf_file

UnCommentLine  'inet_interfaces = all' $conf_file

CommentLine  'inet_interfaces = localhost' $conf_file

UnCommentLine  'home_mailbox = Maildir\/' $conf_file

CommentLine   'mydestination = $myhostname, localhost.$mydomain, localhost' $conf_file


UnCommentLine  'mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain' $conf_file



sed -i -e  "s/#mynetworks = 1.*/mynetworks = $3, 127.0.0.0\/8/" $conf_file

firewall-cmd --add-port=25/tcp --permanent && firewall-cmd --reload

systemctl start postfix.service
systemctl enable postfix.service


