FROM centos:6.8
MAINTAINER Pierre Lejeune <lejeune.pierre.41@gmail.com>

RUN yum -y update ca-certificates
COPY ca-certificates/* /etc/pki/ca-trust/source/anchors/
RUN update-ca-trust force-enable && update-ca-trust extract

RUN yum update -y

RUN curl https://museum.php.net/php5/php-5.2.9.tar.gz -O && tar xfz php-5.2.9.tar.gz && rm php-5.2.9.tar.gz

WORKDIR php-5.2.9

RUN yum -y install httpd gcc libxml2-devel httpd-devel libXpm-devel gmp-devel libicu-devel \
	t1lib-devel aspell-devel openssl-devel bzip2-devel libcurl-devel libjpeg-devel libvpx-devel \
	libpng-devel freetype-devel readline-devel libtidy-devel libxslt-devel

RUN rpm --import https://raw.githubusercontent.com/repoforge/repo-files/master/repo/RPM-GPG-KEY.dag.txt
RUN curl https://ftp.tu-chemnitz.de/pub/linux/dag/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm -O

RUN rpm -K rpmforge-release-0.5.3-1.el6.rf.*.rpm \
    && rpm -i rpmforge-release-0.5.3-1.el6.rf.*.rpm

RUN yum install -y libmcrypt libmcrypt-devel libmhash-devel mysql mysql-server mysql-devel libc-client-devel\
    readline-devel ncurses ncurses-devel readline readline-devel compat-readline5-devel libtool-ltdl libtool-ltdl-devel

#RUN curl  -O
RUN rpm -Uvh http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-3.noarch.rpm \
    && sed -i "s/baseurl=https/baseurl=http/" /etc/yum.repos.d/pgdg-94-centos.repo \
    && yum install -y postgresql94-server postgresql94-devel

RUN ln -s /usr/pgsql-9.4/lib/libpq.so.5.7 /usr/lib/libpq.so

RUN ./configure --with-libdir=lib64 --prefix=/usr/local \
	--with-layout=PHP --with-pear --with-apxs2 --enable-calendar --enable-bcmath --with-gmp --enable-exif --with-mcrypt --with-mhash --with-zlib --with-bz2 \
	--enable-zip --enable-ftp --enable-mbstring --with-iconv --with-gettext --with-pspell --enable-sockets --with-curl --with-curlwrappers --with-gd --enable-gd-native-ttf \
	--with-jpeg-dir=/usr --with-png-dir=/usr --with-zlib-dir=/usr --with-xpm-dir=/usr --with-freetype-dir=/usr --with-t1lib=/usr --with-libxml-dir=/usr \
	--with-mysql=/usr/bin/mysql_config --with-mysqli=/usr/bin/mysql_config --with-pdo-mysql=/usr/bin/mysql_config --enable-soap --with-xmlrpc --with-xsl --with-tidy=/usr \
	--enable-pcntl --enable-sysvshm --enable-sysvmsg --enable-shmop --with-pdo-pgsql=/usr/pgsql-9.4 --with-pgsql=/usr/pgsql-9.4 --with-config-file-scan-dir=/usr/local/lib/conf.d

RUN make && make test && make install
RUN mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.bak

RUN yum -y install wget
RUN wget https://xdebug.org/files/xdebug-2.2.7.tgz
RUN pecl install xdebug-2.2.7

COPY apache-php.conf /etc/httpd/conf.d

COPY xdebug.ini /usr/local/lib/conf.d/xdebug.ini

COPY filesize.ini /usr/local/lib/conf.d/filesize.ini

EXPOSE 80

RUN usermod -u ${HOST_UID:-1000} apache && groupmod -g ${HOST_GID:-1000} apache

VOLUME /var/www/html

CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]