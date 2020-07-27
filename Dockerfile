# this is our first build stage, it will not persist in the final image
FROM ubuntu as intermediate

ARG PERSONAL_TOKEN

# install git
RUN apt-get update && \
	apt-get install -y curl && \
	apt-get install -y git

RUN git clone https://$PERSONAL_TOKEN@github.com/gravityforms/gravityforms
#	curl -sS https://getcomposer.org/installer -o composer-setup.php && \
#	php composer-setup.php --install-dir=/usr/local/bin --filename=composer

FROM wordpress:latest

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
	php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
	composer require --dev phpunit/phpunit && \
	apt-get update && \
	apt-get install -y git && \
	apt-get install -y subversion && \
	apt-get install -y default-mysql-client default-libmysqlclient-dev

WORKDIR /var/www/html
COPY --from=intermediate /gravityforms /usr/src/wordpress/wp-content/plugins/gravityforms

RUN cd /usr/src/wordpress/wp-content/plugins/gravityforms && \
	composer install