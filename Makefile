# MODIFIY THESE THREE SETTINGS
# will also be the Name on the dokku host
PROJECT_NAME=wptest

# dokku.mycompany.com or whatever
DOKKU_HOST=d 

# ussually it's dokku
DOKKU_USER=dokku 

# in case you have want to push something else than master
BRANCH=master

# the name of the local git remote 
GIT_TARGET=live 

# requires the domains plugins and sets the domain
VHOST=wptest.dokku.dudagroup.com 

# You dont have to modify anything below this line
DOKKU_CMD=ssh $(DOKKU_USER)@$(DOKKU_HOST)

download_wordpress:
	echo "Downloading Wordpress...."
	mkdir web
	curl -o master.zip -LOk https://github.com/WordPress/WordPress/archive/master.zip
	unzip -q master.zip -d web
	mv web/WordPress-master/* web
	rm -rf web/WordPress-master
	rm master.zip

configure_wordpress:
	cd web;../tools/create_wp_config.sh

configure_domains:
	$(DOKKU_CMD) domains:set $(PROJECT_NAME) $(VHOST)

setup_git:
	echo "Setting up git remotes...."
	mkdir backups
	echo /backups >> .gitignore
	git init
	git remote add $(GIT_TARGET) $(DOKKU_USER)@$(DOKKU_HOST):$(PROJECT_NAME)
	git add .
	git commit -am "Setup of Project: $(PROJECT_NAME)"

setup_dokku_volume:
	echo "Adding docker volume"
	$(DOKKU_CMD) volume:add $(PROJECT_NAME) /app/web/wp-content

setup_mariadb:
	echo "Creating DB"
	$(DOKKU_CMD) mariadb:create $(PROJECT_NAME)

install: download_wordpress configure_wordpress setup_git deploy setup_dokku_volume setup_mariadb configure_domains
	date > last_install.txt
	git add last_install.txt
	git commit -am "Installation finished, redeployment imminent"
	git push $(GIT_TARGET) $(BRANCH)
	echo "All done! Let's wait 5s....."
	sleep 5 # lets wait, so that the host is up
	open http://$(VHOST)

deploy:
	git push $(GIT_TARGET) $(BRANCH)

backup:
	$(DOKKU_CMD) mariadb:dump $(PROJECT_NAME) > backups/mariadb_latest.sql
	$(DOKKU_CMD) volume:dump $(PROJECT_NAME) > backups/wp-content.tar.gz

clean:
	rm -rf web
	git remote remove dokku
	$(DOKKU_CMD) volume:remove $(PROJECT_NAME) /app/web/wp-content
	$(DOKKU_CMD) mariadb:delete $(PROJECT_NAME)
	$(DOKKU_CMD) undeploy $(PROJECT_NAME)
	
