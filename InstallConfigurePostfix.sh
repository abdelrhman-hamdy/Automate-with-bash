#!/bin/bash
# Example of using the script : ./InstallConfigurePostfix.sh    HostName       DomainName    "NetworkSubnet"
# Example of using the script : ./InstallConfigurePostfix.sh  mail.hamdy.com   hamdy.com      "192.168.1.0\/24"


function EditCongFile(){                      # this function takes 3 argument,1- the field needed to change its value, 2- the value , 3 - conf file path 
sed -i -e  "s/#$1 = .*/$1 = $2/" $3
}

# this function is used to comment a line, it has two arguement, the string pattern , and the conf file path  respectively
function CommentLine(){                        
sed  -i -e "/^$1/ c#$1" $2

}
# this function is used to Uncomment a line, it has two arguement, the string pattern , and the conf file path respectively
function UnCommentLine(){
sed -i -e  "/^#$1/ c$1" $2

}
conf_file=/etc/postfix/main.cf

if [ "$(rpmquery postfix)" = "package postfix is not installed" ];then yum install postfix -y ;else echo " Postfix is installed"; fi  # install the package if not exists

EditCongFile myhostname $1 $conf_file                     #configuring mail server hostname

EditCongFile mydomain   $2  $conf_file                    #configuring mail server domain name

EditCongFile myorigin "\$mydomain" $conf_file             #configuring mail server origin

UnCommentLine  'inet_interfaces = all' $conf_file

CommentLine  'inet_interfaces = localhost' $conf_file

UnCommentLine  'home_mailbox = Maildir\/' $conf_file

CommentLine   'mydestination = $myhostname, localhost.$mydomain, localhost' $conf_file


UnCommentLine  'mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain' $conf_file



sed -i -e  "s/#mynetworks = 1.*/mynetworks = $3, 127.0.0.0\/8/" $conf_file   # configuring mail server accepts requests from the local network

firewall-cmd --add-port=25/tcp --permanent && firewall-cmd --reload

systemctl start postfix.service
systemctl enable postfix.service


