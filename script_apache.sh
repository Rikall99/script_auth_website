#!/bin/bash

# Variables de configuration

DB_SERVER="10.0.16.1"
DB_NAME="auth_db"
DB_USER="admin"
DB_PASS="password"

sudo apt update -y
sudo apt install -y apache2 php php-mysqli

sudo systemctl start apache2
sudo systemctl enable apache2

sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html

sudo a2enmod rewrite
sudo systemctl restart apache2

# Créer le fichier de configuration de la base de données
cat <<EOT > /var/www/html/config.php
<?php
define('DB_SERVER', '$DB_SERVER');
define('DB_USERNAME', '$DB_USER');
define('DB_PASSWORD', '$DB_PASS');
define('DB_NAME', '$DB_NAME');

/* Connexion à la base de données MySQL */
\$link = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_NAME);

// Vérifier la connexion
?>
EOT

# Créer la page de login en PHP
cat <<EOT > /var/www/html/index.php
<?php
include('config.php');

\$error = '';

if(\$_SERVER["REQUEST_METHOD"] == "POST"){{
    \$myusername = mysqli_real_escape_string(\$link, \$_POST['username']);
    \$mypassword = mysqli_real_escape_string(\$link, \$_POST['password']);

    \$sql = "SELECT id FROM users WHERE username = '\$myusername' and password = '\$mypassword'";
    \$result = mysqli_query(\$link, \$sql);
    \$row = mysqli_fetch_array(\$result, MYSQLI_ASSOC);

    \$count = mysqli_num_rows(\$result);

    if(\$count == 1) {{
        header("location: welcome.php");
    }}else {{
        \$error = "Your Login Name or Password is invalid";
    }}
}}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Login Page</title>
</head>
<body>
    <h2>Login Page</h2>
    <form action="" method="post">
        <label>Username :</label>
        <input type="text" name="username"/><br />
        <label>Password :</label>
        <input type="password" name="password"/><br/>
        <input type="submit" value=" Submit "/><br />
    </form>
</body>
</html>
EOT

# Créer une page de bienvenue en PHP
cat <<EOT > /var/www/html/welcome.php
<!DOCTYPE html>
<html>
<head>
    <title>Welcome Page</title>
</head>
<body>
    <h1>Welcome to the site!</h1>
</body>
</html>
EOT

# Redémarrer Apache
sudo systemctl restart apache2

