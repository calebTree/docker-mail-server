FROM fedora:latest
RUN dnf update -y
RUN dnf install -y postfix dovecot telnet
RUN dnf install -y mariadb-server
RUN dnf install -y roundcubemail php php-mysqli
RUN dnf install -y vim procps iputils passwd mutt
# RUN dnf install -y chkconfig
    
# ENV DB_HOST localhost
# ENV DB_USER root

ENV APP_HOST mail
ENV RC_DB_USERNAME roundcube
ENV RC_DB_PASSWD fedora
ENV RC_DB_NAME roundcube
ENV SMTP_PORT 25
ENV MY_NETWORKS 0.0.0.0/0
# roundcube
COPY roundcubemail.conf /etc/httpd/conf.d/roundcubemail.conf
COPY config.inc.php /etc/roundcubemail/config.inc.php
# dovecot
COPY dovecot.conf /etc/dovecot/dovecot.conf
COPY 10-auth.conf /etc/dovecot/conf.d/10-auth.conf
# postfix
COPY main.cf /etc/postfix/main.cf

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

ADD start.sh /start.sh

CMD sh ./start.sh && bash
