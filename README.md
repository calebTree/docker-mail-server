# Build
docker build -t fedora:mail .
# Run
docker run --name mailserver --rm -it -p 80:80 -p 25:25 -p 143:143 -p 110:110 fedora:mail /bin/bash
