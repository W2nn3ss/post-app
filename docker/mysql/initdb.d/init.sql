ALTER USER 'root'@'localhost' IDENTIFIED BY 'root_password';
CREATE DATABASE IF NOT EXISTS post_app;
CREATE USER 'app'@'%' IDENTIFIED BY 'secret';
GRANT ALL PRIVILEGES ON guest_app.* TO 'app'@'%';
FLUSH PRIVILEGES;
