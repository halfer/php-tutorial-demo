# Docker build script for my I (love) PHP live demo

# ********************
# This is the first stage build
# ********************
FROM alpine:3.7 AS build

WORKDIR /root

# Basic dependencies
RUN apk update
RUN apk add --update git

# Fetch repository
RUN git clone https://github.com/halfer/php-tutorial-project.git /var/repos/php-tutorial-project && \
    cd /var/repos/php-tutorial-project && \
    git checkout rebase5

# ********************
# This is the output build
# ********************
FROM alpine:3.7

# Install PHP
RUN apk update
RUN apk add --update php7 php7-session

# Add a web server
RUN apk add apache2 php7-apache2

# Prep Apache
RUN mkdir -p /run/apache2
RUN rm -r /var/www/localhost/htdocs
RUN echo "LoadModule rewrite_module modules/mod_rewrite.so" > /etc/apache2/conf.d/rewrite.conf
RUN echo "ServerName localhost" > /etc/apache2/conf.d/server-name.conf

# Copy web app into place
COPY --from=build /var/repos/php-tutorial-project /var/www/localhost/htdocs

EXPOSE 80

CMD ["/usr/sbin/httpd", "-DFOREGROUND"]
