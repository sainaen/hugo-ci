FROM alpine:3.3

RUN apk add --update git openssh-client && \
    rm -rf /var/cache/apk/* && \
    mkdir /sources && \
    mkdir /sites

COPY ["hugo", "webhooker", "build-site", "/usr/bin/"]

VOLUME ["/sources", "/sites"]

EXPOSE 8000

CMD ["webhooker", "--port", "8000", "--config", "/etc/hugo-ci/config"]
