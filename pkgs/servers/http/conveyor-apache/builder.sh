source $stdenv/setup 1

INSTALL_DIR=$out/conveyor-apache
RUNTIME_LINK=/home/user/.conveyor/runtime/dogfoodsoftware.com/conveyor-apache

PATH=$perl/bin:$PATH

tar xjf $src

cd httpd-*
echo "Configuring..."
configureFlags="--prefix=$INSTALL_DIR $configureFlags"
./configure $configureFlags
echo "Compiling..."
make
echo "Installing..."
make install

echo "Creating runtime link..."
mkdir -p `basename $RUNTIME_LINK`
rm -f $RUNTIME_LINK
ln -s $INSTALL_DIR $RUNTIME_LINK

# Set up the static Conveyor-Stack configuration for Apache.
cd $INSTALL_DIR

# Our own httpd.conf is fundamental to the whole idea.
mv conf/httpd.conf conf/httpd.conf.built
cp $httpdConf ./conf/httpd.conf
# Also copy over our conveyor control scripts.
mkdir $out/bin
cp $bin/* $out/bin 
# Not sure whether it's necessary to copy bin to '$out' rather than
# $INSTALL_DIR, but I think so.

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
DATA_DIR=$home/.conveyor/data/dogfoodsoftware.com/conveyor-apache/
# Note, the data dir may already exist; for instance, the package was
# deleted then re-installed from nix.
mkdir -p $DATA_DIR
# These three directories are refenced by the httpd.conf file.
mkdir -p $DATA_DIR/conf-inc
mkdir -p $DATA_DIR/misc # What's this for?
mkdir -p $DATA_DIR/ssl
mkdir -p $DATA_DIR/htdocs

# We want logs to be both standard and durable, so we create
# our own and then symlink the directory in the nix installation.
mkdir -p $DATA_DIR/logs
rmdir ./logs
ln -s $DATA_DIR/logs logs
