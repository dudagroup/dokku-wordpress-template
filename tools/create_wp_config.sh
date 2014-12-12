#!/bin/sh

grep -A 1 -B 50 'since 2.6.0' wp-config-sample.php > wp-config.php
curl https://api.wordpress.org/secret-key/1.1/salt/ >> wp-config.php
grep -A 50 -B 3 'Table prefix' wp-config-sample.php >> wp-config.php

sed -i .bak "s/'database_name_here'/getenv('DB_NAME')/" wp-config.php
sed -i .bak "s/'username_here'/getenv('DB_USER')/" wp-config.php
sed -i .bak "s/'password_here'/getenv('DB_PASS')/" wp-config.php
sed -i .bak "s/'localhost'/getenv('DB_HOST')/" wp-config.php