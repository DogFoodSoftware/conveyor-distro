source $stdenv/setup 1
source $install_lib

DFS_RUNTIME="$home/.conveyor/runtime/dogfoodsoftware.com/"
CONVEYOR_CORE_RUNTIME="$DFS_RUNTIME/conveyor-core"
source $CONVEYOR_CORE_RUNTIME/runnable/lib/shell-echo.sh

PROJECT_HOME="$out/conveyor/${domain_name}/${bare_name}"
APACHE_INSTALL_DIR="$PROJECT_HOME/runnable"

PATH=$perl/bin:$PATH

tar xjf $src

cd httpd-*
qecho "Configuring..."
configureFlags="--prefix=$APACHE_INSTALL_DIR $configureFlags"
./configure $configureFlags
qecho "Compiling..."
make
qecho "Installing..."
make install

make_runtime_link

# Set up the static Conveyor-Stack configuration for Apache.
cd $APACHE_INSTALL_DIR

# Our own httpd.conf is fundamental to the whole idea.
mv conf/httpd.conf conf/httpd.conf.built
cp $httpdConf ./conf/httpd.conf
# Also copy over our conveyor control scripts.
mkdir $PROJECT_HOME/bin
cp $bin/* $PROJECT_HOME/bin
ln -s $PROJECT_HOME/bin $out/bin

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

# Note '$home', not $HOME. Rather than use 'impure' vars (imported
# from the environment used to launch nix), the 'home' is an argument
# provided by the nix installation expression.
DATA_DIR=$home/.conveyor/data/dogfoodsoftware.com/conveyor-apache/
# TODO: '$DATA_DIR' and '$DATA_DIR/conf-inc' are created by 'conveyor-core'.
mkdir -p $DATA_DIR/misc # What's this for?
mkdir -p $DATA_DIR/ssl
mkdir -p $DATA_DIR/htdocs

# We want logs to be both standard and durable, so we create
# our own and then symlink the directory in the nix installation.
mkdir -p $DATA_DIR/logs
rmdir ./logs
ln -s $DATA_DIR/logs logs

# Next, we automate starting the server on boot. Currently, we support
# openSuSE 13.1. As we add other base systems, this logic will probably move
# to some kind of case statement in a library.

# Check that we can operate as root.
if [[ ! x`/usr/bin/sudo echo foo` == xfoo ]]; then
    qerr "Cannot setup start-on-boot. No access to root."
    exit 87 # TODO: do something with this exit
fi

# TODO: Update this to systemd
# The 'Z_' prefix is so that we get run after the 
/usr/bin/sudo cp $httpdInit /etc/init.d/Z_apache-httpd.init
/usr/bin/sudo chown root /etc/init.d/Z_apache-httpd.init
/usr/bin/sudo chmod 744 /etc/init.d/Z_apache-httpd.init
/usr/bin/sudo /usr/bin/systemctl enable Z_apache-httpd.init.service
/usr/bin/sudo /sbin/SuSEfirewall2 open EXT TCP 8080
/usr/bin/sudo /sbin/SuSEfirewall2 open EXT TCP 8443
