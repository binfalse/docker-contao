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


Let's say you keep your files in `PATH`, then you would run your website as:

    docker run --rm -it \
        -p 8080:80 \
        -v PATH/files/:/var/www/html/files/ \
        -v PATH/templates/:/var/www/html/templates/ \
        -v PATH/system/modules/:/var/www/html/system/modules/ \
        -v PATH/system/config/localconfig.php:/var/www/html/system/config/localconfig.php \
        binfalse/conato

This basically mounts your files from `PATH` to the proper locations in `/var/www/html` of the container and bind its port `80` to port `8080` of your server.
Thus, you should be able to access the contao instance at `example.com:8080`.

Depending on your configuration you may want to link a MySQL container etc.



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


