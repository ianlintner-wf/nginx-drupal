[![Build Status](https://travis-ci.org/ianlintner-wf/nginx-drupal.svg?branch=master)](https://travis-ci.org/ianlintner-wf/nginx-drupal)
[![Join the chat at https://gitter.im/ianlintner-wf/nginx-drupal](https://badges.gitter.im/ianlintner-wf/nginx-drupal.svg)](https://gitter.im/ianlintner-wf/nginx-drupal?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Docker image with Nginx and PHP 5.5.9 optimized for Drupal 7](#docker-image-with-nginx-and-php-559-optimized-for-drupal-7)
  - [Packages included](#packages-included)
    - [Other changes from the original repo](#other-changes-from-the-original-repo)
  - [Important:](#important)
  - [To build](#to-build)
  - [To run](#to-run)
  - [Other Notes](#other-notes)
    - [XDEBUG](#xdebug)
    - [Drush & Console Table](#drush-&-console-table)
  - [Fig](#fig)
  - [Running Drush](#running-drush)
    - [License](#license)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Docker image with Nginx and PHP 5.5.9 optimized for Drupal 7


This image is build using Ubuntu 14.04 with Nginx and PHP 5.5.9 and is optimized to run Drupal 7 and it is 
designed to use the docroot which is how Acquia repositories are setup if you are hosting your production site
on Acquia.

This repo is a fork of: https://github.com/iiiepe/docker-nginx-drupal if your site does not use docroot format
this container maybe a better option.


**Drupal Site Code must be located /var/www/docroot**

- Repository root --> /var/www
 - docroot --> /var/www/docroot
   - sites
 - scripts
 - tools
 
## Packages included
- nginx
- php
- composer
- drush

### Other changes from the original repo
* Added SSL cert for https and nginx config is set to serve https/ssl
* Removed the mail server configuration. Use drupal SMTP module with mailcatcher.

[MailCatcher](https://hub.docker.com/r/zolweb/docker-mailcatcher/~/dockerfile/)

## Important:

- Logs are at /var/log/supervisor so you can map that directory
- Application root directory is /var/www so make sure you map the application there
- The web root in this container /var/www/docroot this is set up to match how Acquia Repos are structured.
- Nginx configuration was provided by https://github.com/perusio/drupal-with-nginx but it's modified

## To build

    $ make build

    or

    $ docker build -t yourname/nginx-drupal .


## To run
Nginx will look for files in /var/www so you need to map your application to that directory.

**The actual site will be run from /var/www/docroot** 

```bash
docker run -d -p 8000:80 -v application:/var/www yourname/nginx-drupal
```

If you want to link the container to a MySQL/MariaDB contaier do:

```bash
docker run -d -p 8000:80 -v application:/var/www my_mysql_container:mysql yourname/nginx-drupal
```

The startup.sh script will add the environment variables with MYSQL_ to /etc/php5/fpm/pool.d/env.conf so PHP-FPM detects them. If you need to use them you can do:
<?php getenv("SOME_ENV_VARIABLE_THAT_HAS_MYSQL_IN_THE_NAME"); ?>

## Other Notes
- The -e PHP_OPCACHE will turn the opcache on or off when you run the container
- Mount Script will run automatically on startup it is designed if you need to mount a folder for configs or shared files.

```bash
docker run -d -e PHP_OPCACHE=enabled -v "application:/var/www"  -v "mountscript.sh:/usr/local/bin/mount.sh"  espressodev/nginx-drupal:latest
```

### XDEBUG
If you want to use xdebug there is a tag. It sends the connections back to the default docker bridge on port 9000.
The debug key is *dgbp*

```bash
docker run -d -e PHP_OPCACHE=disabled -v "application:/var/www"  -v "mountscript.sh:/usr/local/bin/mount.sh"  espressodev/nginx-drupal:xdebug
```


### Drush & Console Table 
**IF PEAR IS DOWN**
In the temporary to get drush running there is a copy of the console table on my repo in github. It can be downloaded and installed in the package location

```bash
cd /tmp
curl -O https://raw.githubusercontent.com/ianlintner-wf/drush_console_table/master/Table.php
mkdir -p  ~/.composer/vendor/drush/drush/lib/Console_Table-1.1.3/
cp Table.php ~/.composer/vendor/drush/drush/lib/Console_Table-1.1.3/Table.php
```


## Fig

    mysql:
      image: mysql
      expose:
        - "3306"
      environment:
        MYSQL_ROOT_PASSWORD: 123
    web:
      image: espressodev/nginx-drupal
      volumes:
        - application:/var/www
        - logs:/var/log/supervisor
        - mountscript:/usr/local/bin/mount.sh
      ports:
        - "80:80"
        - "443:443"
      links:
        - "mysql:mysql"

## Running Drush
With Fig this is actually easier and is the recommended way since if you're running Docker without fig, you'll have to link all containers before you run drush.

    $ fig run --rm web drush

### License
Released under the MIT License.
