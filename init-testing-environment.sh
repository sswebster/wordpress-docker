#!/bin/bash

cd /var/www/html/

#1. check if wordpress is already installed/configured
if (sudo -u www-data -- wp core is-installed)
then

	#2. check if the database is ready
	if ! (sudo -u www-data -- wp db check)
	then
		# wait a moment for the database container
		sleep 1
		exit 1;
	fi

	#3. init the testing instance
	sudo -u www-data -- wp scaffold plugin-tests /usr/src/wordpress/wp-content/plugins/gravityforms --force
	cd /usr/src/wordpress/wp-content/plugins/gravityforms && bash tests/bin/install.sh wordpress_tests wordpress wordpress db
fi

#4. back to the root WP folder
cd /var/www/html/

#5. execute the entrypoint of the parent image
bash docker-entrypoint.sh "$@"
