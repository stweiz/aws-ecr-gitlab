FROM docker:stable-dind
RUN wget -O /usr/bin/docker-credential-ecr-login https://amazon-ecr-credential-helper-releases.s3.us-east-2.amazonaws.com/0.4.0/linux-amd64/docker-credential-ecr-login && \
chmod 755 /usr/bin/docker-credential-ecr-login && \
mkdir /root/.docker
COPY config.json /root/.docker