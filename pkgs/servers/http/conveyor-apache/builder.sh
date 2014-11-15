source $stdenv/setup 1

PATH=$perl/bin:$PATH

tar xjf $src

cd httpd-*
./configure --prefix=$out \
    --enable-dav=shared \
    --enable-dav-fs=shared \
    --enable-ssl=shared \
    --enable-so \
    --enable-rewrite=shared \
    --enable-deflate=shared
make
make install

mkdir -p /home/user/.conveyor/runtime/dogfoodsoftware.com/conveyor/distro/pkgs/servers/http/conveyor-apache
rm /home/user/.conveyor/runtime/dogfoodsoftware.com/conveyor/distro/pkgs/servers/http/conveyor-apache/runnable
ln -s $out/ /home/user/.conveyor/runtime/dogfoodsoftware.com/conveyor/distro/pkgs/servers/http/conveyor-apache/runnable

# Set up the static Conveyor-Stack configuration for Apache.
cd $out

# Our own httpd.conf is fundamental to the whole idea.
mv conf/httpd.conf conf/httpd.conf.built
cp $httpdConf ./conf/httpd.conf
# Also copy over our conveyor control scripts.
cp $bin/* ./bin

# These two files fix issues we had at one time. At
# this point, I don't remember exactly what they are.
# They're kept on because they continue to work.
# However, it would be good to either a) document why
# they're necessary or b) see about using the default
# again.
mv conf/mime.types conf/mime.types.built
cp $httpdMime ./conf/mime.types
mv conf/magic conf/magic.built
cp $httpdMagic ./conf/magic

# Setup the Conveyor runtime directories. Note '$home', not $HOME. Rather
# than use 'impure' vars (imported from the environment used to launch
# nix), the 'home' is an argument provided by the nix installation
# expression.
DATA_DIR=$home/.conveyor/data/dogfoodsoftware.com/conveyor/distro/pkgs/servers/http/conveyor-apache/
# Note, the data dir may already exist; for instance, the package was
# deleted then re-installed from nix.
mkdir -p $DATA_DIR
# These three directories are refenced by the httpd.conf file.
mkdir -p $DATA_DIR/conf-inc
mkdir -p $DATA_DIR/misc # What's this for?
mkdir -p $DATA_DIR/ssl
# 'htdocs' to be removed; replaced by 'conveyor-host' package.
mkdir -p $DATA_DIR/htdocs
mv ./htdocs/* $DATA_DIR/htdocs
rmdir ./htdocs
if [ ! -f $DATA_DIR/htdocs ]; then
    ln -s $DATA_DIR/htdocs htdocs
fi

# We want logs to be both standard and durable, so we create
# our own and then symlink the directory in the nix installation.
mkdir -p $DATA_DIR/logs
rmdir ./logs
if [ ! -f $DATA_DIR/logs ]; then
    ln -s $DATA_DIR/logs logs
fi
