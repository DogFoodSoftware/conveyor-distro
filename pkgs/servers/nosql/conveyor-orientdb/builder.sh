source $stdenv/setup 1
source $install_lib

INSTALL_DIR="$out/conveyor/${domain}/${bare_name}"
PHP_CLIENT_DIR="$INSTALL_DIR/php-orient"
DATA_DIR="$home/.conveyor/data/dogfoodsoftware.com/conveyor-orientdb"

# Install program files and our own control scripts.
mkdir -p $INSTALL_DIR
cd $INSTALL_DIR
tar -xzf $src --strip 1
mkdir $out/bin
for i in $bin_patches; do
    # Honestly, I don't know why the last '.*' is necessary, but without it,
    # BASE_NAME ends up like 'orientdb.patch'.
    BASE_NAME=`echo $i | perl -pe 's|/nix/store/\w+-([^.]+).*|$1|'`
    OUT_NAME="$out/bin/${BASE_NAME}"
    patch -d "$out/bin" -o "$OUT_NAME" "$INSTALL_DIR/bin/${BASE_NAME}.sh" "$i"
    chmod a+x "$OUT_NAME"
done
cp $orientdb_console_bin $out/bin/orientdb-console
for i in $obin_patches; do
    BASE_NAME=`echo $i | perl -pe 's|/nix/store/\w+-([^.]+\.sh).*|$1|'`
    patch "$INSTALL_DIR/bin/${BASE_NAME}" "$i"
done

# Setup data directory.
mkdir -p "$DATA_DIR"

# TODO: move this to conveyor-core install lib.
function make_data_dir() {
    SRC="$INSTALL_DIR/$1"
    TARGET="$DATA_DIR/$2"

    if [ ! -d "$TARGET" ]; then
	# Setup target directory.
	mkdir -p "$TARGET"
	chmod 755 "$TARGET"
	chmod -R u+w "$SRC"
	# Move everything from source to target. Will cause error if no
	# files to move, so first we check.
	if [[ `ls "$SRC" | wc -l` -gt 0 ]]; then
	    mv --target-directory="$TARGET" "$SRC/"* "$SRC/".[!.]*
	fi
	# Now replace source with link to target.
	rmdir "$SRC"
    else # The directories have already been setup. Or logic will
	 # probably change as Conveyor updates firm up, but for now,
	 # we'll just move the newly installed directory over to
	 # preserve the data. Either way, we need to set up the links
	 # to the conveyor data dir.
	mv "$SRC" "$SRC".new
    fi
    ln -s "$TARGET" "$SRC"
}

make_data_dir log log
make_data_dir config conf
make_data_dir databases databases
# TODO: We're doing this because OrientDB really wants to put the
# console history in the bin directory and reasonable googling has
# failed to turn up configuration to say otherwise. May need to submit
# patch to the code. Originally tried 'chmod'-ing the install bin, but
# nix appearently goes back and cleans up the chmods after the
# script... and besides that would break out 'runtime inviolate'
# rule. So, until we find a way to configure that out, we have to move
# the 'bin'.
make_data_dir bin bin
chmod u+w "$DATA_DIR/bin"
chmod u+w "$DATA_DIR/conf/"*
cp "$conf/"* "$DATA_DIR/conf"
# TODO: And now the 'orientdb-server-config.xml' workaround. Keeps
# eyes out for more elegant solution. Problem is, despite claming that
# '${ORIENTDB_HOME}' can be used in the files, we get errors that the
# property cannot be resolved. So we hard code, but still want to
# respect the home of the user and not assume anything on that
# point. So we read the file and rewrite doing our own substitition.
ORIENTDB_HOME="$INSTALL_DIR"
SERVER_CONF="$DATA_DIR/conf/orientdb-server-config.xml"
# TODO: I thought in-place replacement of file possible, but seemed to
# produce an error.
# mv "$SERVER_CONF" "$SERVER_CONF".tmp
# sed -e "s|\${ORIENTDB_HOME}|${ORIENTDB_HOME}|" "${SERVER_CONF}.tmp" > "$SERVER_CONF"
# rm "$SERVER_CONF".tmp

chmod u-w $out

# Install PHP client dependencies
COMPOSER="${conveyor_composer}/conveyor-composer/composer.phar"
COMPOSER_DATA="$home/.conveyor/data/dogfoodsoftware.com/conveyor-composer/"
mkdir "$PHP_CLIENT_DIR"
cp -a $client_src/* "$PHP_CLIENT_DIR"
cd "$PHP_CLIENT_DIR"
export COMPOSER_HOME="$COMPOSER_DATA/home"
export COMPOSER_VENDOR_DIR="$COMPOSER_DATA/vendor"
export COMPOSER_BIN_DIR="$COMPOSER_DATA/vendor/bin"
# The 'cacert-bundle.crt' loaded by PHP is conditioned on HOME.
HOME=$home && php "$COMPOSER" --no-dev install

make_runtime_link
