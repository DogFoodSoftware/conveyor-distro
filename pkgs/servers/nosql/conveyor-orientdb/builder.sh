source $stdenv/setup 1

PATH=$perl/bin:$PATH

INSTALL_DIR=$out/conveyor-orientdb

# Install program files and our own control scripts.
mkdir -p $INSTALL_DIR
cd $INSTALL_DIR
tar -xzf $src --strip 1
mkdir $out/bin
cp "$conveyor_bin/*" $out/bin
cp "$orientdb_bin/*" $INSTALL_DIR/bin

# Setup data directory.
DATA_DIR="$home/.conveyor/data/dogfoodsoftware.com/conveyor-orientdb"
mkdir -p "$DATA_DIR"
mkdir -p "$DATA_DIR/log"
chmod 755 "$DATA_DIR/log"
mkdir -p "$DATA_DIR/conf"
chmod 755 "$DATA_DIR/conf"

# Copy anything currently in log and then replace the install log dir
# to the Conveyor data log.
chmod -r u+w $INSTALL_DIR/log
mv $INSTALL_DIR/log/* $$DATA_DIR/log
rmdir $INSTALL_DIR/log/*
ln -s $DATA_DIR/log $INSTALL_DIR/log

# Same with config.
cp "$INSTALL_DIR/config

chmod u-w $out
chmod u-w $out/data.built

