#!/bin/bash

# Install MariaDB
sudo apt update
sudo apt install -y mariadb-server

# Secure MariaDB installation (optional but recommended)
#sudo mysql_secure_installation

sudo bash -c 'echo -e "\nskip-networking=0\nskip-bind-address" >> /etc/mysql/mariadb.conf.d/50-server.cnf'

sudo service mariadb start

# Log in to MariaDB and create a new admin user with all privileges
sudo mysql -e "CREATE USER 'admin'@'%' IDENTIFIED BY 'password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;"
sudo mysql -e "FLUSH PRIVILEGES;"

# Create the auth_db database
sudo mysql -e "CREATE DATABASE auth_db;"

# Create a new user for the auth_db database
sudo mysql -e "CREATE USER 'auth_user'@'%' IDENTIFIED BY 'password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON auth_db.* TO 'auth_user'@'%';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Create the users table in the auth_db database
sudo mysql -e "
USE auth_db;
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL
);
"

# Insert a test user
sudo mysql -e "
USE auth_db;
INSERT INTO users (username, password) VALUES ('user', PASSWORD('password'));
"
sudo service mariadb restart

echo "Database and user setup complete."
