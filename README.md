This is a simple [Docker](https://www.docker.com/) containerized mail server that runs [Dovecot](https://www.dovecot.org/), [Postfix](http://www.postfix.org/) and [Roundcube](https://roundcube.net/). Advanced security such as SMTP authentication or TLS is left unconfigured. One use case might be for developing software which requires emailing users. Simply build and run the container with your choice of `APP_DOMAIN` environment variable (which sets the recipient email domain) then follow the prompts. To send an email use the full domain such as `user@host.domain.tld`. Finally, configure your app (in development mode) with an SMTP domain set to `http://localhost/roundcubemail` or `host.docker.internal`.
# Examples
## Build
`docker build -t fedora:mail .`
## Run
`docker run --name mailserver -e APP_DOMAIN=chemlab.edu --rm -it -p 80:80 -p 25:25 -p 143:143 -p 110:110 fedora:mail`
### Thanks to
https://github.com/Codegyre/DockerPostfixDovecot/blob/master/Dockerfile
### Production Ready Mail Server
https://github.com/docker-mailserver/docker-mailserver
