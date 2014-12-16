source $stdenv/setup 1

echo -e "-------\n\n$apache_home\n\n--------"

PATH=$perl/bin:$PATH

tar xjf $src

DATA_DIR=$home/.conveyor/data/dogfoodsoftware.com/conveyor/distro/pkgs/development/intterpreters/conveyor-php
mkdir -p $DATA_DIR
mkdir -p $DATA_DIR/conf

cd php-*
#conditionally include the postgres headers
# PG_RUNNABLE=$DFS_HOME/third-party/postgres/runnable
# if [ -d $PG_RUNNABLE ]; then 
#     CONFIG="$CONFIG --with-pgsql=$PG_RUNNABLE"
# fi
# #conditionally include the mysql headers
# MYSQL_RUNNABLE=$DFS_HOME/third-party/mysql/runnable
# if [ -d $MYSQL_RUNNABLE ]; then 
#     # on 64 bit system, the it is necessary to refer explicitly to lib64 (which is a symlink in the Kibbles mysql install); it makes no sense because the default 'lib' doesn't work but specifying lib64 does... whatever, this is how it needs to be at the moment (mysql 5.5.21 and PHP 5.3.6)
#     CONFIG="$CONFIG --with-mysql=$MYSQL_RUNNABLE --with-libdir=lib64"
# fi
configureFlags="--prefix=$out --with-config-file-path=$DATA_DIR/conf $configureFlags"
echo "$configureFlags" > config_line
./configure $configureFlags
make
# Need to allow write to the apache modules dir for the 'libphp5.so'
# object file.
chmod u+w ${apache_home}/modules
make install
chmod u-w ${apache_home}/modules
rm -f /home/user/.conveyor/data/dogfoodsoftware.com/conveyor/distro/pkgs/servers/http/conveyor-apache/conf-inc/`basename $php_http_conf`
cp "$php_http_conf" /home/user/.conveyor/data/dogfoodsoftware.com/conveyor/distro/pkgs/servers/http/conveyor-apache/conf-inc/php.httpd.conf

# echo -e "\n\nA\n\n"
# make install-binaries
# echo -e "\n\nB\n\n"
# make install-modules
# echo -e "\n\nC\n\n"
# make install-headers
# echo -e "\n\nD\n\n"

# Setup the PHP module for apache.
# APACHE_MODULES_DIR=$APACHE_HOME/modules
# mkdir ../modules
# cp -p .libs/libphp5.so ../modules
# mkdir -p $APACHE_MODULES_DIR
# rm $APACHE_MODULES_DIR/libphp5.so
# ln -s $BUILD_DIR/modules/libphp5.so $APACHE_MODULES_DIR
# cd ..
# Cleanup the exploded source directory.
# rm -rf php-*

# ./bin/pear install mdb2
# ./bin/pear install mdb2_driver_pgsql
# ./bin/pear install mdb2_driver_mysql

# ln -s $PHP_HOME/src/app $BUILD_DIR

mkdir -p $DATA_DIR/data/logs
