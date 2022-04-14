# Build
`docker build -t fedora:mail .`
# Run
`docker run --name mailserver -e APP_DOMAIN=chemlab.edu --rm -it -p 80:80 -p 25:25 -p 143:143 -p 110:110 fedora:mail`
### Optional manual setup w/ defualt config files & ignore `start.sh`.
If you're interested in manually configuring the mail server without automatically executing the `start.sh` script. Checkout the defualt config files from `5d99cd5`, then rebuild the container image, then run the container with `/bin/bash` as an argument to override the `CMD` command.
- `git checkout 5d99cd5 *.cf *.php *.conf`
- `docker run --name mailserver -e APP_DOMAIN=chemlab.edu --rm -it -p 80:80 -p 25:25 -p 143:143 -p 110:110 fedora:mail /bin/bash`

Or just remove/comment-out the relevenat `COPY` and/or `CMD` etc. commands in the `Dockerfile`.
#### Thanks to:
https://github.com/Codegyre/DockerPostfixDovecot/blob/master/Dockerfile
