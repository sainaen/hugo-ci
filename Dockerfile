FROM alpine:3.3

RUN apk add --update git && \
    rm -rf /var/cache/apk/* && \
	mkdir /sources && \
	mkdir /sites

COPY ["hugo", "webhooker", "build-site", "/usr/bin/"]

RUN chmod a+x /usr/bin/webhooker && \
	chmod a+x /usr/bin/hugo && \
	chmod a+x /usr/bin/build-site

VOLUME ["/sources", "/sites"]

EXPOSE 8000

CMD ["webhooker", "--port", "8000", "--config", "/etc/webhooker/config"]
