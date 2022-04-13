FROM fedora:latest
RUN dnf update -y
RUN dnf install -y postfix dovecot

ENV DB_HOST localhost
ENV DB_USER root

# SMTP ports
EXPOSE 25
EXPOSE 587
# POP ports
EXPOSE 110
EXPOSE 995
# IMAP ports
EXPOSE 143
EXPOSE 993
