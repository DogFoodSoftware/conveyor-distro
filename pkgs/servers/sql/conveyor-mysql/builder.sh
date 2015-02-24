source $stdenv/setup 1
source $install_lib

PATH=$perl/bin:$PATH

tar xzf $src

set_install_dir

cd mysql-*
cmake -DCMAKE_INSTALL_PREFIX:PATH=$INSTALL_DIR
#TODO: everythings so dual core now-a-days, but why conditionalaize? even select n by procs?
make -j 2
make install

DATA_DIR=$home/.conveyor/data/dogfoodsoftware.com/conveyor-mysql/data
mkdir -p $DATA_DIR

chmod u+w $INSTALL_DIR
chmod u+w $INSTALL_DIR/data
mv $INSTALL_DIR/data $INSTALL_DIR/data.built
ln -s $DATA_DIR $INSTALL_DIR/data
chmod u-w $INSTALL_DIR
chmod u-w $INSTALL_DIR/data.built

# Do we need to path others?
echo "Patching 'mysql' binary; with library path:"
echo -e "\t$libPath"
f=$INSTALL_DIR/bin/mysql
patchelf \
  --set-interpreter "$(cat ${gcc_home}/nix-support/dynamic-linker)" \
  --set-rpath "$(patchelf --print-rpath "$f"):$libPath" \
  "$f"
patchelf --shrink-rpath "$f"

$INSTALL_DIR/scripts/mysql_install_db --basedir=$INSTALL_DIR --datadir=$DATA_DIR

ln -s $INSTALL_DIR/bin $out/bin
make_runtime_link
