# Docker image with Nginx and PHP 5.5.9 optimized for Drupal 7
This image is build using Ubuntu 14.04 with Nginx and PHP 5.5.9 and is optimized to run Drupal 7 and it is 
designed to use the docroot which is how Acquia repositories are setup if you are hosting your production site
on Acquia.

**Drupal Site Code must be located /var/www/docroot**

- Repository root --> /var/www
 - docroot --> /var/www/docroot
   - sites
 - scripts
 - tools

Includes:

- nginx
- php
- composer
- drush

Important:

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