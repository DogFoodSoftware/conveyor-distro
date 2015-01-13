source $stdenv/setup 1

PATH=$perl/bin:$PATH

tar xjf $src

BUILD_DIR="$out/conveyor-php"
DFS_RUNTIME="$home/.conveyor/runtime/dogfoodsoftware.com/"
RUNTIME_LINK="$DFS_RUNTIME/conveyor-php"
DATA_DIR=$home/.conveyor/data/dogfoodsoftware.com/conveyor-php
mkdir -p $DATA_DIR
mkdir -p $DATA_DIR/conf

cd php-*
#conditionally include the postgres headers
# PG_RUNNABLE=$DFS_HOME/third-party/postgres/runnable
# if [ -d $PG_RUNNABLE ]; then 
#     CONFIG="$CONFIG --with-pgsql=$PG_RUNNABLE"
# fi

# The bulk of the flags come from the nix expression; these locate the
# nix supplied libraries.
configureFlags="--prefix=$BUILD_DIR \
                --with-config-file-path=$DATA_DIR/conf \
                --with-apxs2=$DFS_RUNTIME/conveyor-apache/bin/apxs \
                --with-mysql=$mysql_home \
                $configureFlags"
echo "$configureFlags" > config_line
# This fixes a problem with PHP where it cannot find the glibc iconv
# header file.
export GETTEXT_DIR=$gettext_home
./configure $configureFlags
make -j 2
# Need to allow write to the apache modules dir for the 'libphp5.so'
# object file.
chmod u+w ${apache_home}/conveyor-apache/modules
make install
chmod u-w ${apache_home}/conveyor-apache/modules
APACHE_CONF_PATH=/home/user/.conveyor/data/dogfoodsoftware.com/conveyor-apache/conf-inc
if [ -f $APACHE_CONF_PATH/php.httpd.conf ]; then
    chmod u+w $APACHE_CONF_PATH/php.httpd.conf
    rm -f $APACHE_CONF_PATH/php.httpd.conf
fi
cp "$php_http_conf" $APACHE_CONF_PATH/php.httpd.conf

# Setup the PHP module for apache.
# APACHE_MODULES_DIR=$APACHE_HOME/modules
# mkdir ../modules
# cp -p .libs/libphp5.so ../modules
# mkdir -p $APACHE_MODULES_DIR
# rm $APACHE_MODULES_DIR/libphp5.so
# ln -s $BUILD_DIR/modules/libphp5.so $APACHE_MODULES_DIR
# cd ..

# Two fixes for pear. 1): it appears to use '$HOME' somewhere as this
# dies unless we set HOME. 2) For some reason, the 'http_proxy' was
# getting set to 'http://nodtd.invalid/'.
export HOME="$home"
$BUILD_DIR/bin/pear config-set http_proxy ''
$BUILD_DIR/bin/pear install mdb2
# ./bin/pear install mdb2_driver_pgsql
$BUILD_DIR/bin/pear install mdb2_driver_mysql

rm -f ${home}/.conveyor/data/dogfoodsoftware.com/conveyor-php/conf/php.ini
if [[ $is_devel == true ]]; then
    # Nix adds a hash to 'php_ini', but we need the name to be simple for
    # PHP.
    cp $php_ini_development ${home}/.conveyor/data/dogfoodsoftware.com/conveyor-php/conf/php.ini
else
    cp $php_ini_production ${home}/.conveyor/data/dogfoodsoftware.com/conveyor-php/conf/php.ini
fi
cp $php_cli_ini ${home}/.conveyor/data/dogfoodsoftware.com/conveyor-php/conf/

mkdir -p $DATA_DIR/data/logs
rm -f $RUNTIME_LINK
ln -s $BUILD_DIR $RUNTIME_LINK
ln -s $BUILD_DIR/bin $out/bin
