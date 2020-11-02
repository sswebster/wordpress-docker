ARG WORDPRESS_VERSION

# Use intermediate build stage to pull down private repos
FROM ubuntu as intermediate

# Add personal token from .env file
ARG PERSONAL_TOKEN

# Install git and dependencies
RUN apt-get update && \
	apt-get install -y curl && \
	apt-get install -y git

# Clone Addons
COPY git-clone-list.sh .
COPY repos.list .
RUN chmod +x git-clone-list.sh
RUN mkdir plugins && cd plugins && bash ../../git-clone-list.sh ../../repos.list $PERSONAL_TOKEN

# Build Wordpress image

FROM $WORDPRESS_VERSION

# Install dependencies, git, composer, mysql client, phpunit, and subversion

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && \
	php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
	composer require --dev phpunit/phpunit && \
	apt-get update && \
	apt-get install -y git && \
	apt-get install -y subversion && \
	apt-get install -y default-mysql-client default-libmysqlclient-dev && \
	pecl install xdebug && \
	docker-php-ext-enable xdebug

# Copy over Gravityforms from build stage

WORKDIR /var/www/html
COPY --from=intermediate /plugins /usr/src/wordpress/wp-content/plugins

#Run Composer install on Gravityforms

RUN cd /usr/src/wordpress/wp-content/plugins/gravityforms && \
	composer install
	# bash tests/bin/install.sh wordpress wordpress wordpress tests-db
