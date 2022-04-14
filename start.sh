#!/bin/bash

# setup variables
green() {
  echo -e '\e[32m'$1'\e[m';
}
cyan() {
  echo -e '\e[36m'$1'\e[m';
}
lightgreen() {
  echo -e '\e[1;32m'$1'\e[m';
}
red() {
  echo -e '\e[1;31m'$1'\e[m';
}
readonly MYSQLD=`which mysqld`
readonly MYSQL=`which mysql`
readonly HTTPD=`which httpd`
readonly PHPFPM=`which php-fpm`
readonly DOVECOT=`which dovecot`

echo "starting app"
echo "full hostname: $APP_HOST.$APP_DOMAIN"

#export HOST_IP=$(/sbin/ip route|awk '/default/ { print $3 }')
#echo "$HOST_IP dockerhost" >> /etc/hosts
echo "127.0.0.1     $APP_HOST.$APP_DOMAIN" >> /etc/hosts
echo "127.0.0.1     $APP_DOMAIN" >> /etc/hosts

# roundcube
# cp -p /etc/roundcubemail/defaults.inc.php /etc/roundcubemail/config.inc.php
sed -i "s/{{APP_HOST}}/$APP_HOST/g" /etc/roundcubemail/config.inc.php
sed -i "s/{{APP_DOMAIN}}/$APP_DOMAIN/g" /etc/roundcubemail/config.inc.php
sed -i "s/{{SMTP_PORT}}/$SMTP_PORT/g" /etc/roundcubemail/config.inc.php
# roundcube database
sed -i "s/{{RC_DB_USERNAME}}/$RC_DB_USERNAME/g" /etc/roundcubemail/config.inc.php
sed -i "s/{{RC_DB_PASSWD}}/$RC_DB_PASSWD/g" /etc/roundcubemail/config.inc.php
sed -i "s/{{RC_DB_NAME}}/$RC_DB_NAME/g" /etc/roundcubemail/config.inc.php

# start php service
mkdir /run/php-fpm
$PHPFPM

# start httpd service
$HTTPD
# /etc/httpd/conf.d/roundcubemail.conf
# <IfModule mod_authz_core.c>
#     # Apache 2.4
#     Require local
#     Require all granted
# </IfModule>
# <IfModule mod_authz_core.c>
#     # Apache 2.4
#     Require local
#     Require all granted
# </IfModule>

# setup mariadb mysql
echo "user=root" >> /etc/my.cnf
mysql_install_db
red "this gets stuck, just press [ENTER]"
$MYSQLD &
# mysql_secure_installation

# setup roundcube database
# credit: https://clubmate.fi/shell-script-to-create-mysql-database
# (to do)
# Construct the MySQL query
readonly Q1="CREATE DATABASE IF NOT EXISTS $RC_DB_NAME CHARACTER SET utf8 COLLATE utf8_bin;"
readonly Q2="GRANT ALL PRIVILEGES ON $RC_DB_NAME.* TO $RC_DB_USERNAME@'localhost' IDENTIFIED BY '$RC_DB_PASSWD';"
readonly Q3="FLUSH PRIVILEGES;"
readonly SQL="${Q1}${Q2}${Q3}"
# Run the actual command
$MYSQL -uroot "-p$MARIADB_ROOTPWD" -e "$SQL"
# Let the user know the database was created
# initalize roundcube
cyan "doing more stuff ..."
$MYSQL -h "localhost" -u $RC_DB_USERNAME "-p$RC_DB_PASSWD" "$RC_DB_NAME" < "/usr/share/roundcubemail/SQL/mysql.initial.sql"

# dovecot
# sed -i "s/{{**}}/$**/g" /etc/dovecot/dovecot.conf 
sed -i "s/disable_plaintext_auth = yes/disable_plaintext_auth = no/g" /etc/dovecot/conf.d/10-auth.conf
# sed -i "s/#mail_location =/mail_location = maildir:~/Maildir/g" /etc/dovecot/conf.d/10-mail.conf
echo "mail_location = maildir:~/Maildir" >> /etc/dovecot/conf.d/10-mail.conf
sed -i "s/ssl = required/ssl = no/g" /etc/dovecot/conf.d/10-ssl.conf
# sed -i "s/ssl_cert = </etc/pki/dovecot/certs/dovecot.pem/#ssl_cert = </etc/pki/dovecot/certs/dovecot.pem/g" /etc/dovecot/conf.d/10-ssl.conf
# sed -i "s/ssl_key = </etc/pki/dovecot/private/dovecot.pem/#ssl_key = </etc/pki/dovecot/private/dovecot.pem/g" /etc/dovecot/conf.d/10-ssl.conf
# $DOVECOT

# postfix
sed -i "s/{{APP_HOST}}/$APP_HOST/g" /etc/postfix/main.cf
sed -i "s/{{APP_DOMAIN}}/$APP_DOMAIN/g" /etc/postfix/main.cf
# number option to `s' command may not be zero
# sed -i "s/{{MY_NETWORKS}}/$MY_NETWORKS/g" /etc/postfix/main.cf

newaliases
postfix start

lightgreen "The script is done."
lightgreen "Database $RC_DB_NAME and user $RC_DB_USERNAME created with a password you chose."
cyan "comment out lines:"
green "ssl_cert = </etc/pki/dovecot/certs/dovecot.pem\nssl_key = </etc/pki/dovecot/private/dovecot.pem"
green "in: /etc/dovecot/conf.d/10-ssl.conf"
cyan "then start dovecot by just typing 'dovecot'"
cyan "create users with (replace <user1> with a username):"
green "useradd --create-home -s /sbin/nologin <user1>; passwd <user1>"
cyan "send email to:"
green "<user1>@$APP_HOST.$APP_DOMAIN"
