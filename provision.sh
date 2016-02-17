#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

sudo usermod -a -G www-data vagrant

sudo apt-get update

sudo apt-get -y install git
sudo apt-get -y install mc

sudo apt-get -y install nginx

sudo apt-get -y install php5 php5-fpm php-apc php5-cli php5-curl php5-dev php5-gd php5-imagick php5-mcrypt php5-memcache php5-mysqlnd php5-pspell php5-sqlite php5-tidy php5-xdebug php5-xmlrpc php5-json php5-xsl

echo "mysql-server-5.6 mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server-5.6 mysql-server/root_password_again password root" | sudo debconf-set-selections

apt-get -y install mysql-server-5.6

sed -i s/\;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/ /etc/php5/fpm/php.ini
sed -i s/display_errors\ =\ Off/display_errors\ =\ On/ /etc/php5/fpm/php.ini
sed -i s/max_execution_time\ =\ 30/max_execution_time\ =\ 300/ /etc/php5/fpm/php.ini
sed -i s/listen\ =\ 127.0.0.1:9000/listen\ =\ \\/var\\/run\\/php5-fpm.sock/ /etc/php5/fpm/pool.d/www.conf

sudo echo ';xdebug extension
zend_extension=xdebug.so
xdebug.default_enable=1
xdebug.idekey="ide.xdebug"
xdebug.remote_enable=1
xdebug.remote_autostart=0
xdebug.remote_port=9000
xdebug.remote_handler=dbgp
xdebug.remote_log="/var/log/xdebug/xdebug.log"
xdebug.remote_host="10.0.2.2"
' > /etc/php5/mods-available/xdebug.ini

sudo echo 'server {
    set $srvnm "localhost";
    set $web "/var/www/web/";
    set $index "index.php";
    set $charset "utf-8";
    set $fcp "unix:/var/run/php5-fpm.sock";

    listen  80;
    server_name $srvnm;
    root $web;

    sendfile off;
    charset $charset;

    location / {
        index  $index;
        try_files $uri $uri/ /$index?$args;
    }
    
    location ~ \.(js|css|png|jpg|gif|swf|ico|pdf)$ {
        try_files $uri = 404;
    }

    location ~ \.php {
        include fastcgi_params;

        fastcgi_split_path_info  ^(.+\.php)(.*)$;

        set $fsn /$index;
        if (-f $document_root$fastcgi_script_name){
            set $fsn $fastcgi_script_name;
        }

        fastcgi_pass   $fcp;
        fastcgi_buffer_size 128k;
        fastcgi_buffers 256 16k;
        fastcgi_busy_buffers_size 256k;
        fastcgi_temp_file_write_size 256k;

        fastcgi_param  SCRIPT_FILENAME  $document_root$fsn;
        fastcgi_param  PATH_INFO        $fastcgi_path_info;
        fastcgi_param  PATH_TRANSLATED  $document_root$fsn;
    }

    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }
}' > /etc/nginx/sites-available/default

sudo sed -i 's/127\.0\.0\.1/0\.0\.0\.0/g' /etc/mysql/my.cnf
mysql -uroot -proot -e 'USE mysql; UPDATE `user` SET `Host`="%" WHERE `User`="root" AND `Host`="localhost"; DELETE FROM `user` WHERE `Host` != "%" AND `User`="root"; FLUSH PRIVILEGES;'

sudo php5enmod mcrypt

sudo service nginx restart
sudo service php5-fpm restart
sudo service mysql restart

# installing composer
curl -sS https://getcomposer.org/installer | php
# move composer globally
sudo mv composer.phar /usr/local/bin/composer

# updating composer
sudo composer self-update

composer global require "fxp/composer-asset-plugin:1.1.1"

cd /var/www/
composer create-project --prefer-dist yiisoft/yii2-app-basic tmp
mv -f tmp/* ./
mv -f tmp/.* ./
rm -rf tmp 
sudo composer self-update
composer global update
composer update

echo '
----------------------------------------
DONE!
----------------------------------------
';
