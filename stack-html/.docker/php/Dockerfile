FROM composer

FROM php:7.2-fpm-alpine

MAINTAINER Pierre LEJEUNE <lejeune.pierre.41@gmail.com>

COPY --from=composer /usr/bin/composer /usr/local/bin/composer

ENV APCU_VERSION 5.1.8

RUN apk add --no-cache \
        ca-certificates \
        icu-libs \
        git \
        unzip \
        zlib-dev && \
    apk add --no-cache --virtual .build-deps \
        $PHPIZE_DEPS \
        icu-dev && \
    docker-php-ext-install \
        intl \
        zip && \
    pecl install apcu-${APCU_VERSION} && \
    docker-php-ext-enable apcu && \
    docker-php-ext-enable opcache && \
    docker-php-ext-install pdo_mysql && \
    echo "short_open_tag = off" >> /usr/local/etc/php/php.ini && \
    echo "date.timezone = Europe/Paris" >> /usr/local/etc/php/conf.d/symfony.ini && \
    echo "opcache.max_accelerated_files = 20000" >> /usr/local/etc/php/conf.d/symfony.ini && \
    echo "realpath_cache_size=4096K" >> /usr/local/etc/php/conf.d/symfony.ini && \
    echo "realpath_cache_ttl=600" >> /usr/local/etc/php/conf.d/symfony.ini && \
    apk del .build-deps && \
    apk add gosu --update --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
    addgroup bar && \
    adduser -D -h /home/foo -s /bin/sh -G bar foo && \
    chown foo:bar -R /home/foo && \
    # Installation de https://packagist.org/packages/hirak/prestissimo
    composer global require hirak/prestissimo

RUN apk add shadow && usermod -u ${HOST_UID:-1001} foo && groupmod -g ${HOST_GID:-1001} bar

RUN composer config --global --auth gitlab-token.gitlab.com QD29Mp5f8AFN5BwvE4AC

ADD entrypoint.sh /entrypoint

RUN ["chmod", "+x", "/entrypoint"]

ENTRYPOINT ["/entrypoint"]
