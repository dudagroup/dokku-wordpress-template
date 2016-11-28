**This plugin is out of date, we recommend this one: https://github.com/dokku-community/dokku-wordpress. Successfully tested on Dokku 7.2.**


dokku-wordpress-template
========================

Wordpress can be quite a .... hassle to set up on Dokku. This template makes is considerably easier.


Requirements:
- dokku (latest)
- https://github.com/wmluke/dokku-domains-plugin
- https://github.com/ohardy/dokku-mariadb
- https://github.com/ohardy/dokku-volume


Extract the files into a new folder, edit the variables on to of the Makefile and call ```make install```

E.g.:
```
git clone https://github.com/dudagroup/dokku-wordpress-template.git myproject
cd myproject
rm -rf .git # except if your contributing to this :-)
vi Makefile
make install
```

If everything succeeded you'll have a new instance running!

Please be aware, that this is just a Makefile..... and still under development.
