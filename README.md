# Docker image for CONTAO

This [Dockerfile](Dockerfile) compiles into a Docker image for [Contao](https://contao.org/).

## Usage

The Contao site in the image is fully functional - all you need to do is mounting personalised files "over" the default versions into the image.
Typically you would mount:

* `files/` - those are your uploaded images etc
* `templates/` - themes and layout adjustments etc
* `system/modules/` - extensions you installed
* `system/config/localconfig.php` - configuration for database etc

plus maybe other configuration files in `system/config/`...

### Simple Example

Let's say you keep your files in `$PATH`, then you would run your website as:

    docker run --rm -it \
        -p 8080:80 \
        -v $PATH/files/:/var/www/html/files/ \
        -v $PATH/templates/:/var/www/html/templates/ \
        -v $PATH/system/modules/:/var/www/html/system/modules/ \
        -v $PATH/system/config/localconfig.php:/var/www/html/system/config/localconfig.php \
        binfalse/conato

This basically mounts your files from `PATH` to the proper locations in `/var/www/html` of the container and bind its port `80` to port `8080` of your server.
Thus, you should be able to access the contao instance at `example.com:8080`.

Depending on your configuration you may want to link a MySQL container etc.



### Using Docker-Compose and a MySQL Database

Let's again say your individual data is stored in `$PATH` and you want to run the website using a MySQL database, then you can compose the following containers

	version: '2'
	services:
			
			contao:
					image: binfalse/contao
					restart: unless-stopped
					container_name: contao
					links:
							- contao_db
					ports:
							- "8080:80"
					volumes:
							- $PATH/files:/var/www/html/files
							- $PATH/templates:/var/www/html/templates:ro
							- $PATH/system/modules:/var/www/html/system/modules
							- $PATH/system/config/localconfig.php:/var/www/html/system/config/localconfig.php
			
			contao_db:
					image: mariadb
					restart: always
					container_name: contao_db
					environment:
							MYSQL_DATABASE: contao_database
							MYSQL_USER: contao_user
							MYSQL_PASSWORD: contao_password
							MYSQL_ROOT_PASSWORD: very_secret
					volumes:
							- $PATH/database:/var/lib/mysql

This will create 2 containers:

* `contao` based on this image, all user-based files are mounted into the proper locations
* `contao_db` a [MariaDB](https://hub.docker.com/_/mariadb/) to provide a MySQL server

To make Contao speak to the MariaDB server you need to configure the database connection in `$PATH/system/config/localconfig.php` just like:

    $GLOBALS['TL_CONFIG']['dbDriver'] = 'MySQLi';
    $GLOBALS['TL_CONFIG']['dbHost'] = 'contao_db';
    $GLOBALS['TL_CONFIG']['dbUser'] = 'contao_user';
    $GLOBALS['TL_CONFIG']['dbPass'] = 'contao_password';
    $GLOBALS['TL_CONFIG']['dbDatabase'] = 'contao_database';
    $GLOBALS['TL_CONFIG']['dbPconnect'] = false;
    $GLOBALS['TL_CONFIG']['dbCharset'] = 'UTF8';
    $GLOBALS['TL_CONFIG']['dbPort'] = 3306;
    $GLOBALS['TL_CONFIG']['dbSocket'] = '';

Here, the database should be accessible at `contao_db:3306`, as it is setup in the compose file above.


If you're running contao with "Rewrite URLs" using an `.htaccess` you also need to update [Apache](https://httpd.apache.org/)'s configuration to allow for rewrites.
Thus, you may for example mount the follwoing file to `/etc/apache2/sites-available/000-default.conf`:

	<VirtualHost *:80>
		ServerAdmin webmaster@localhost
		DocumentRoot /var/www/html
		<Directory /var/www/>
			AllowOverride All
			Options FollowSymLinks
		</Directory>
		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined
	</VirtualHost>

This tells Apache to allow everything in any `.htaccess` file in `/var/www`.

## LICENSE

        Docker Image for Contao
        Copyright (C) 2017 Martin Scharm <https://binfalse.de/contact/>

        This program is free software: you can redistribute it and/or modify
        it under the terms of the GNU General Public License as published by
        the Free Software Foundation, either version 3 of the License, or
        (at your option) any later version.

        This program is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        GNU General Public License for more details.

        You should have received a copy of the GNU General Public License
        along with this program.  If not, see <http://www.gnu.org/licenses/>.


