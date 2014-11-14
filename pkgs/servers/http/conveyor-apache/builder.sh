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

# Set up the static Conveyor-Stack configuration for Apache.
cd $out
# These files are replaced by customizations.
mv conf/httpd.conf conf/httpd.conf.built
mv conf/mime.types conf/mime.types.built
mv conf/magic conf/magic.built

# Our own httpd.conf is fundamental to the whole idea.
cp $httpdConf ./conf/httpd.conf
chmod u+w ./conf/httpd.conf
# Use '|' because '$out' contains forward slashes. Need to double
# escape once for bash, then once for perl. I originally tried to use
# the 'builtins' 'readFile' and 'toFile' to process the template
# httpd.conf in the Nix expression, but was having trouble getting it
# to work. This is a bit less elegant, but expedient.
perl -p -i.bak -e "s|\\$\\{out\\}|$out|g" ./conf/httpd.conf
# After this setup, the master 'httpd.conf' should only be changed
# with a new apache installation or update. Individual sites
# (VirtualHosts) may be changed by manipulating files in the
# 'runtime-conf' which is included from the master file.
echo "Include $DATA_DIR/runtime-conf/*.httpd.conf" >> ./conf/httpd.conf
chmod u-w ./conf/httpd.conf

# These two files fix issues we had at one time. At
# this point, I don't remember exactly what they are.
# They're kept on because they continue to work.
# However, it would be good to either a) document why
# they're necessary or b) see about using the default
# again.
cp $httpdMime ./conf/mime.types
cp $httpdMagic ./conf/magic

# Setup the Conveyor runtime directories. Note '$home', not $HOME. Rather
# than use 'impure' vars (imported from the environment used to launch
# nix), the 'home' is an argument provided by the nix installation
# expression.
DATA_DIR=$home/.conveyor/data/conveyor-apache
# Note, the data dir may already exist; for instance, the package was
# deleted then re-installed from nix.
mkdir -p $DATA_DIR
# These three directories are refenced by the httpd.conf file.
mkdir -p $DATA_DIR/runtime-conf
mkdir -p $DATA_DIR/misc # What's this for?
mkdir -p $DATA_DIR/ssl
# 'htdocs' to be removed; replaced by 'conveyor-host' package.
mkdir -p $DATA_DIR/htdocs
mv ./htdocs/* $DATA_DIR/htdocs
rmdir ./htdocs
ln -s $DATA_DIR/htdocs htdocs

# We want logs to be both standard and durable, so we create
# our own and then symlink the directory in the nix installation.
mkdir $DATA_DIR/logs
rmdir ./logs
ln -s $DATA_DIR/logs logs
