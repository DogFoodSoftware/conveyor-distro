source $stdenv/setup 1

PATH=$perl/bin:$PATH

INSTALL_DIR=$out/conveyor-orientdb

mkdir -p $INSTALL_DIR
cd $INSTALL_DIR
tar -xzf $src --strip 1
mkdir $out/bin
cp "$conveyor_bin/*" $out/bin

DATA_DIR="$home/.conveyor/data/dogfoodsoftware.com/conveyor-orientdb"
mkdir -p "$DATA_DIR"
mkdir -p "$DATA_DIR/log"
chmod 755 "$DATA_DIR/log"

chmod -r u+w $INSTALL_DIR/log
mv $INSTALL_DIR/log/* $$DATA_DIR/log
rmdir $INSTALL_DIR/log/*
ln -s $DATA_DIR/log $INSTALL_DIR/log

chmod u-w $out
chmod u-w $out/data.built

