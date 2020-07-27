# Use intermediate build stage to pull down private repos
FROM ubuntu as intermediate

# Add personal token from .env file
ARG PERSONAL_TOKEN

# Install git and dependencies
RUN apt-get update && \
	apt-get install -y curl && \
	apt-get install -y git

# Clone Gravityforms
RUN git clone https://$PERSONAL_TOKEN@github.com/gravityforms/gravityforms

# Build Wordpress image

FROM wordpress:latest

# Install dependencies, git, composer, mysql client, phpunit, and subversion

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
	php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
	composer require --dev phpunit/phpunit && \
	apt-get update && \
	apt-get install -y git && \
	apt-get install -y subversion && \
	apt-get install -y default-mysql-client default-libmysqlclient-dev

# Copy over Gravityforms from build stage

WORKDIR /var/www/html
COPY --from=intermediate /gravityforms /usr/src/wordpress/wp-content/plugins/gravityforms

#Run Composer install on Gravityforms

RUN cd /usr/src/wordpress/wp-content/plugins/gravityforms && \
	composer install