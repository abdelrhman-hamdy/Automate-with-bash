#!/bin/bash

# This scrpt installs mongodb service,then edits its configuration file to accept requests from any IP and enable authenticaion,
# and finally  creates admin user and another normal user 


function checkService {
systemctl is-active --quiet mongod.service                                      # check if the Mongodb service is up and running
if ($? -eq 0 ); then 
echo "Mongodb Server is Up and Running"
else
echo "Failed to start Mongodb Server"
fi 
}


yum install mongodb-org -y                                                      # installing Mongodb 

sed -i -E 's/^  bindIp: (127.0.0.1)/  bindIp: 0\.0\.0\.0/'  /etc/mongod.conf    # configure mongodb to accept requests from any ip 

systemctl daemon-reload  && systemctl enable --now mongod                       # enable and start  mongodb



mongo <<EOF                                                                      
use admin
db.createUser(                                                                  # Create Admin user
{
user: "adminUser",
pwd: "adminPassword",
roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
}
)
db.createUser({                                                                 # Create user to access a certain database
    user:"hamdy",
    pwd : "semifinal123456",
    roles : [{role:"readWrite",db:"server123456"}]})
EOF


sed -i -E 's/#security:/security: \n   authorization: "enabled" /'  /etc/mongod.conf  # Enable authentication in mongodb server

systemctl restart mongod.service                                                      # reload the service


checkService                                                                          # Call the declared function above to check the mongodb service
