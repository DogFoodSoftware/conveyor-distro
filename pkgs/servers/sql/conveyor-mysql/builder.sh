source $stdenv/setup 1

PATH=$perl/bin:$PATH

tar xzf $src

cd mysql-*
cmake -DCMAKE_INSTALL_PREFIX:PATH=$out
# ./configure --prefix=$out
#TODO: everythings so dual core now-a-days, but why conditionalaize? even select n by procs?
make -j 2
make install

DATA_DIR=$home/.conveyor/data/dogfoodsoftware.com/distro-mysql/data
mkdir -p $DATA_DIR

chmod u+w $out
chmod u+w $out/data
mv $out/data $out/data.built
ln -s $DATA_DIR $out/data
chmod u-w $out
chmod u-w $out/data.built

# Do we need to path others?
echo "Patching 'mysql' binary; with library path:"
echo -e "\t$libPath"
f=$out/bin/mysql
patchelf \
  --set-interpreter "$(cat ${gcc_home}/nix-support/dynamic-linker)" \
  --set-rpath "$(patchelf --print-rpath "$f"):$libPath" \
  "$f"
patchelf --shrink-rpath "$f"

$out/scripts/mysql_install_db --basedir=$out --datadir=$DATA_DIR
