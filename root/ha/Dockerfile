FROM gcr.io/google_containers/ubuntu-slim:0.9

MAINTAINER zhaoming<zhaoming@cloudin.kmail.com>

COPY ha /ha/ha
COPY config.yaml /ha/config.yaml

WORKDIR /ha
ENTRYPOINT ["./ha"]