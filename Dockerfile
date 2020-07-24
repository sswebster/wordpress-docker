FROM wordpress:latest

RUN apt-get update
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
	php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
	apt-get install -y git
WORKDIR /var/www/html
RUN git clone --verbose https://github.com/gravityforms/gravityforms /usr/src/wordpress/wp-content/plugins/gravityforms