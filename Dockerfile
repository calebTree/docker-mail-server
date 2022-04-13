FROM fedora:latest
RUN dnf update -y
RUN dnf install -y postfix dovecot telnet
RUN dnf install -y mariadb-server
RUN dnf install -y roundcubemail php php-mysqli
RUN dnf install -y vim procps iputils passwd mutt
# RUN dnf install -y chkconfig

# ENV DB_HOST localhost
# ENV DB_USER root

# SMTP ports
EXPOSE 25
# EXPOSE 587
# POP ports
EXPOSE 110
# EXPOSE 995
# IMAP ports
EXPOSE 143
# EXPOSE 993
# HTTP ports
EXPOSE 80
# EXPOSE 443
