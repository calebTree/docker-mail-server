green() {
  echo -e '\e[32m'$1'\e[m';
}
cyan() {
  echo -e '\e[36m'$1'\e[m';
}
red() {
  echo -e '\e[1;31m'$1'\e[m';
}
readonly DOVECOT=`which dovecot`
green "\n### The setup script completed!! ###"
green "Mysql database [$RC_DB_NAME] and user [$RC_DB_USERNAME] created with password [$RC_DB_PASSWD]."
red "\nManually complete these final steps."
green "Comment out lines in:"
cyan "'vim +14 /etc/dovecot/conf.d/10-ssl.conf'"
cyan "#ssl_key = </etc/pki/dovecot/private/dovecot.pem"
cyan "'vim +15 /etc/dovecot/conf.d/10-ssl.conf'"
cyan "#ssl_cert = </etc/pki/dovecot/certs/dovecot.pem"
green "\nThen start dovecot."
cyan "$DOVECOT"
green "\nCreate user(s):"
green "(replace <user1> below with your choice username)"
cyan "useradd --create-home -s /sbin/nologin <user1>; passwd <user1>"
green "Send email(s) to:"
cyan "<user1>@$APP_HOST.$APP_DOMAIN"
green "\nNavigate to:"
cyan "'http://localhost/roundcubemail'."
green "\nOptionally run:"
cyan "'mysql_secure_installation'"
green "\nCheck admin email with:"
cyan "'mutt -f /root/Maildir/'"
green "\nLeave the container with:"
cyan "'Ctrl + P + Ctrl Q'.\n"
