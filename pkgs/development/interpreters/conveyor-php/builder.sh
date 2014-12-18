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

configureFlags="--prefix=$out --with-config-file-path=$DATA_DIR/conf $configureFlags --with-mysql=$mysql_home"
echo "$configureFlags" > config_line
./configure $configureFlags
make
# Need to allow write to the apache modules dir for the 'libphp5.so'
# object file.
chmod u+w ${apache_home}/modules
make install
chmod u-w ${apache_home}/modules
APACHE_CONF_PATH=/home/user/.conveyor/data/dogfoodsoftware.com/conveyor/distro/pkgs/servers/http/conveyor-apache/conf-inc
if [ -f $APACHE_CONF_PATH/php.httpd.conf ]; then
    chmod u+w $APACHE_CONF_PATH/php.httpd.conf
    rm -f $APACHE_CONF_PATH/php.httpd.conf
fi
cp "$php_http_conf" $APACHE_CONF_PATH/php.httpd.conf

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
