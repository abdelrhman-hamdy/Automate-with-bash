#!/bin/bash

function checkService {
systemctl is-active --quiet mongod.service                                      # check if the service is up and running
if ($? -eq 0 ); then 
echo "Mongodb Server is Up and Running"
else
echo "Failed to start Mongodb Server"
fi 
}


yum install mongodb-org -y

#sleep 20
sed -i -E 's/^  bindIp: (127.0.0.1)/  bindIp: 0\.0\.0\.0/'  /etc/mongod.conf    # configure mongodb to accept requests from any ip 

systemctl daemon-reload  && systemctl enable --now mongod                       # enable and start  mongodb


#sleep 10

mongo <<EOF
use admin
db.createUser(
{
user: "admin123",
pwd: "admin123",
roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
}
)
db.createUser({
    user:"hamdy",
    pwd : "semifinal123456",
    roles : [{role:"readWrite",db:"server123456"}]})
EOF


sed -i -E 's/#security:/security: \n   authorization: "enabled" /'  /etc/mongod.conf  # Enable authentication in mongodb server

systemctl restart mongod.service

#sleep 5
checkService