#!/bin/bash

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
green "\nNavigate to:"
cyan "'http://localhost/roundcubemail'."
green "\nLogin with:"
cyan "'user1:$USER1_PSWD'"
green "\nOptional setup:"
green "\nCreate more users:"
green "(replace <username> below with your choice username)"
cyan "useradd --create-home -s /sbin/nologin <username>; passwd <username>"
green "\nSend email(s) to:"
cyan "<username>@$APP_HOST.$APP_DOMAIN"
green "\nMore secure MySQL:"
cyan "'mysql_secure_installation'"
green "\nCheck admin email with:"
cyan "'mutt -f /root/Maildir/'"
green "\nLeave the container with:"
cyan "'Ctrl + P + Ctrl Q'.\n"
