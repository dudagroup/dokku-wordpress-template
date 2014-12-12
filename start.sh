#!/bin/sh
echo "Copying files...."
cp -ur /app/web/wp-content.orig/* /app/web/wp-content
chmod -R 777 /app/web/wp-content
echo "Finished."
vendor/bin/heroku-php-nginx web/