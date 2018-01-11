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




