if [ ! -d /u01/middleware/apache-tomcat-10.1.31 ]
then
    sudo apt update -y
    sudo apt install -y openjdk-17-jdk
    sudo mkdir -p /u01/middleware
    sudo chown ubuntu:ubuntu -R /u01

    wget -O /u01/middleware/apache-tomcat-10.1.31.tar.gz https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.31/bin/apache-tomcat-10.1.31.tar.gz
    tar -xzvf /u01/middleware/apache-tomcat-10.1.31.tar.gz -C /u01/middleware
    rm /u01/middleware/apache-tomcat-10.1.31.tar.gz

    if [ -f /tmp/tomcat.service ]; then
        sudo cp /tmp/tomcat.service /etc/systemd/system/
        sudo systemctl daemon-reload
        sudo systemctl enable tomcat.service
        sudo systemctl start tomcat
    else
        echo "tomcat.service file not found in /tmp"
        exit 1
    fi
fi

if systemctl is-active --quiet tomcat; then
    sudo systemctl stop tomcat
fi

if [ -d /u01/middleware/apache-tomcat-10.1.31/webapps ]; then
    rm -rf /u01/middleware/apache-tomcat-10.1.31/webapps/HelloWorld-0.0.1-SNAPSHOT.war
    cp /tmp/HelloWorld-0.0.1-SNAPSHOT.war /u01/middleware/apache-tomcat-10.1.31/webapps
    sudo systemctl start tomcat
else
    echo "Tomcat webapps directory not found."
fi
