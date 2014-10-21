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
mv conf/httpd.conf conf/httpd.conf.built
mv conf/mime.types conf/mime.types.built
mv conf/magic conf/magic.built

cp $httpdConf ./conf/httpd.conf
cp $httpdMime ./conf/mime.types
echo G
cp $httpdMagic ./conf/magic
echo "H: HOME - $HOME"
echo "home: $home"

# Setup the Conveyor runtime directories. Note '$home', not $HOME. Rather
# than use impure vars, the 'home' is an argument provided by the nix
# installation expression.
DATA_DIR=$home/.conveyor/data/`basename $out`
echo "I: DATA-DIR: $DATA_DIR"
mkdir -p $DATA_DIR
echo J

# Note, the data dir may already exist; for instance, the package was
# deleted then re-installed from nix.
mkdir -p $DATA_DIR/runtime-conf
ls -l ./conf/httpd.conf
chmod u+w ./conf/httpd.conf
# Use '|' because '$out' contains forward slashes. Need to double
# escape once for bash, then once for perl. I originally tried to use
# the 'builtins' 'readFile' and 'toFile' to process the template
# httpd.conf in the Nix expression, but was having trouble getting it
# to work. This is a bit less elegant, but expedient.
perl -p -i.bak -e "s|\\$\\{out\\}|$out|g" ./conf/httpd.conf
echo "Include $DATA_DIR/runtime-conf/*.httpd.conf" >> ./conf/httpd.conf
chmod u-w ./conf/httpd.conf

mkdir -p $DATA_DIR/misc

mkdir -p $DATA_DIR/ssl

mkdir -p $DATA_DIR/htdocs
mv ./htdocs/* $DATA_DIR/htdocs
rmdir ./htdocs
ln -s $DATA_DIR/htdocs htdocs

mkdir $DATA_DIR/logs
rmdir ./logs
ln -s $DATA_DIR/logs logs
