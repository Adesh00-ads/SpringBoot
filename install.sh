if [ ! -d /u01/middleware/apache-tomcat-10.1.31 ]; then
    sudo apt update -y
    sudo apt install -y openjdk-17-jdk
    sudo mkdir -p /u01/middleware
    sudo chown ubuntu:ubuntu -R /u01

    # Download Tomcat
    TOMCAT_URL="https://downloads.apache.org/tomcat/tomcat-10/v10.1.31/bin/apache-tomcat-10.1.31.tar.gz"
    wget -O /u01/middleware/apache-tomcat-10.1.31.tar.gz "$TOMCAT_URL"

    # Verify download success before extraction
    if [ $? -ne 0 ]; then
        echo "Failed to download Tomcat. Exiting."
        exit 1
    fi

    # Extract Tomcat
    tar -xzvf /u01/middleware/apache-tomcat-10.1.31.tar.gz -C /u01/middleware
    if [ $? -ne 0 ]; then
        echo "Failed to extract Tomcat. Exiting."
        exit 1
    fi
    rm /u01/middleware/apache-tomcat-10.1.31.tar.gz

    # Set up systemd service if the file exists
    if [ -f /tmp/tomcat.service ]; then
        sudo cp /tmp/tomcat.service /etc/systemd/system/
        sudo systemctl daemon-reload
        sudo systemctl enable tomcat.service
        sudo systemctl start tomcat
    else
        echo "tomcat.service file not found in /tmp. Exiting."
        exit 1
    fi
fi

# Stop Tomcat if it's currently running
if systemctl is-active --quiet tomcat; then
    sudo systemctl stop tomcat
fi

# Deploy WAR file if webapps directory exists
if [ -d /u01/middleware/apache-tomcat-10.1.31/webapps ]; then
    rm -rf /u01/middleware/apache-tomcat-10.1.31/webapps/HelloWorld-0.0.1-SNAPSHOT.war
    cp /tmp/HelloWorld-0.0.1-SNAPSHOT.war /u01/middleware/apache-tomcat-10.1.31/webapps

    # Restart Tomcat
    sudo systemctl start tomcat
else
    echo "Tomcat webapps directory not found. Exiting."
    exit 1
fi
