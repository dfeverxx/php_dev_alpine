FROM alpine:3.7 as base

COPY docker /docker/

# See https://github.com/gliderlabs/docker-alpine/issues/184
RUN \
  sed -i 's/http\:\/\/dl-cdn.alpinelinux.org/https\:\/\/alpine.global.ssl.fastly.net/g' /etc/apk/repositories && \
  apk update && apk upgrade

RUN /docker/scripts/install-packages.sh \
    && /docker/scripts/ensure-www-data.sh \
    && mv /docker/php-entrypoint /usr/local/bin/

ENTRYPOINT ["php-entrypoint"]

CMD ["php", "-a"]


RUN apk --no-cache add php7-fpm \
    && mv /docker/www.conf /etc/php7/php-fpm.d/www.conf

EXPOSE 9000

CMD ["php-fpm7"]
