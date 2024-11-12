#!/bin/bash

if [ ! -d /u01/middleware/apache-tomcat-10.1.31 ]
then
    sudo apt update -y
    sudo apt install -y openjdk-17-jdk

    mkdir -p /u01/middleware
    sudo chown ubuntu:ubuntu -R /u01

    wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.31/bin/apache-tomcat-10.1.31.tar.gz -p /u01/middleware
    tar -xzvf /u01/middleware/apache-tomcat-10.1.31.tar.gz -C /u01/middleware
    rm /u01/middleware/apache-tomcat-10.1.31.tar.gz

    sudo cp /tmp/tomcat.service /etc/systemd/system/
    sudo systemctl reload 
    sudo systemctl enable tomcat.service
    sudo systemctl start tomcat
fi
sudo systemctl stop tomcat
rm -rf /u01/middleware/apache-tomcat-10.1.31/webapps/HelloWorld-0.0.1-SNAPSHOT.war
cp /tmp/HelloWorld-0.0.1-SNAPSHOT.war /u01/middleware/apache-tomcat-10.1.31/webapps
sudo systemctl start tomcat

