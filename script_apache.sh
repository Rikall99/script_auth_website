#!/bin/bash

# Variables de configuration

DB_SERVER="10.0.16.45"
DB_NAME="auth_db"
DB_USER="auth_user"
DB_PASS="password"

sudo apt update
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
cat <<EOT > /var/www/html/login.php
<?php
include('config.php');

\$error = '';

if(\$_SERVER["REQUEST_METHOD"] == "POST"){{
    \$myusername = mysqli_real_escape_string(\$link, \$_POST['username']);
    \$mypassword = mysqli_real_escape_string(\$link, \$_POST['password']);

    \$sql = "SELECT id FROM users WHERE username = '\$myusername' and password = Password('\$mypassword')";
    \$result = mysqli_query(\$link, \$sql);
    \$row = mysqli_fetch_array(\$result, MYSQLI_ASSOC);

    \$count = mysqli_num_rows(\$result);

    if(\$count == 1) {{
        header("location: index.php");
    }}else {{
        \$error = "Your Login Name or Password is invalid";
    }}
}}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Login Page</title>
    <style>
    @font-face {
        font-family: 'Marianne';
        src: url(https://www.info.gouv.fr/build/fonts/Marianne-Regular.4349f045.woff2) format('woff2');
    } 
    body {
        font-family: Marianne;
    }
    h2 {
        color: #333333;
        text-align: center;
        margin-top: 150px;
    }
    form {
        width: 300px;
        margin: 0 auto;
        padding: 20px;
        background-color: #f2f2f2;
        border: 1px solid #ccc;
        border-radius: 5px;
    }
    label {
        display: block;
        margin-bottom: 10px;
    }
    input[type="text"],
    input[type="password"] {
        width: 100%;
        padding: 5px;
        margin-bottom: 20px;
        border: 1px solid #ccc;
        border-radius: 5px;
    }
    input[type="submit"] {
        width: 100%;
        padding: 10px;
        background-color: #4CAF50;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }
    input[type="submit"]:hover {
        background-color: #45a049;
    }
    </style>
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
cat <<EOT > /var/www/html/index.php
<!DOCTYPE html>

<html>
<head>
    <title>Index Page</title>
    <style>
        @font-face {
            font-family: 'Marianne';
            src: url(https://www.info.gouv.fr/build/fonts/Marianne-Regular.4349f045.woff2) format('woff2');
                    } 
        body {
            background-color: #f2f2f2;
            font-family: Marianne;
        }
        h1 {
            color: #333333;
            flex-box: center;
            text-align: center;
            margin-top: 150px;
        }
    </style>
</head>
<body>
    <h1>Bienvenue sur notre site</h1>
</body>
</html>
EOT

# Redémarrer Apache
sudo systemctl restart apache2

