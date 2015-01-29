# Nix builder script; no '#!'
source $stdenv/setup 1

INSTALL_DIR=$out/conveyor/${domain_name}/${bare_name}

if [[ "$src" == "$test_path" ]]; then
    mkdir -p `dirname $INSTALL_DIR`
    ln -s $src $INSTALL_DIR
else 
    mkdir -p $INSTALL_DIR
    cp -a $src/* $INSTALL_DIR
fi

CONVEYOR_CORE_DATA="$home/.conveyor/data/dogfoodsoftware.com/${bare_name}"
CC_DATABASES="$CONVEYOR_CORE_DATA/databases"
CC_DOCUMENTATION="$CONVEYOR_CORE_DATA/documentation"
for DIR in "$home/.conveyor" \
           "$home/.conveyor/data" \
           "$home/.conveyor/data/dogfoodsoftware.com" \
           "$CONVEYOR_CORE_DATA" \
           "$CC_DATABASES" \
           "$CC_DOCUMENTATION"; do
    # We do the check and create because the '-p' can mask problems. Since
    # we build from the bottom up, the 'create parents' effect is not
    # necessary.
    if [ ! -d "$DIR" ]; then
	mkdir "$DIR"
    fi
done

echo "Linking nix profile into conveyor runtime..."
rm -f $home/.conveyor/runtime
ln -s $home/.nix-profile/conveyor $home/.conveyor/runtime

if [ ! -f "$home/.conveyor/host-id" ]; then
    # TODO: Cheating! 'uuidgen' not part of the nixpkgs at this time.
    /usr/bin/uuidgen > "$home/.conveyor/host-id"
fi

ODB_CREDENTIALS="$home/.conveyor/data/dogfoodsoftware.com/conveyor-core/odb-credentials"
if [[ ! -d $CC_DATABASES/conveyor ]]; then
    if [[ ! $(type -P orientdb-console) ]]; then
	"ERROR: Did not find Conveyor (Orient)DB, nor 'orientdb-console'."
	exit 2 # 500
    fi
    
    # First, we create or read the credentials.
    if [[ ! -f $ODB_CREDENTIALS ]]; then
	echo "Generating OrientDB admin account..."
	# Originally used 'admin', but in that case, the password is
	# not updated as of 2.0-RC1 (issue https://github.com/orientechnologies/orientdb/issues/3329)
	ODB_USERNAME='conveyor'
	# TODO: See note re. 'uuidgen' above.
	ODB_PASSWORD=`/usr/bin/uuidgen`

	cat <<EOF > $ODB_CREDENTIALS
ODB_USERNAME="$ODB_USERNAME"
ODB_PASSWORD="$ODB_PASSWORD"
EOF
    else
	source "$ODB_CREDENTIALS"
    fi

    ORIENTDB_HOME="$home/.conveyor/runtime/dogfoodsoftware.com/conveyor-orientdb"
    if [ ! -h "$ORIENTDB_HOME" ]; then
	echo "Could not find '$ORIENTDB_HOME'; bailing out." >&2
	exit 2
    fi
    SERVER_CONF="${ORIENTDB_HOME}/config/orientdb-server-config.xml"
    cp "${src}/conf/orientdb-server-config.xml" "${SERVER_CONF}"
    for VAR in '${ORIENTDB_HOME}' '${ODB_USERNAME}' '${ODB_PASSWORD}' '${CONVEYOR_CORE_DATA}'; do
	# TODO: I thought in place replacement worked, but it seemed to
	# produce errors and I didn't have time to look into it.
	VAR_VALUE=`eval echo "$VAR"`
	mv "$SERVER_CONF" "$SERVER_CONF".tmp
	sed -e "s|${VAR}|${VAR_VALUE}|" "${SERVER_CONF}.tmp" > "$SERVER_CONF"
	rm "$SERVER_CONF".tmp
    done

    # Status is 0 == true (in bash) if not running.
    export home
    export stdenv
    # Status is 0 == true (in bash) if not running, so...
    if ! orientdb status > /dev/null; then # is running.
	orientdb stop
	TRY_COUNT=0
	while true ; do
	    ps -ef | grep java | grep $ORIENTDB_HOME/lib/orientdb-server > /dev/null || break
	    sleep 1
	    TRY_COUNT=$(($TRY_COUNT + 1))
	    [[ $TRY_COUNT -ge 20 ]] && $(echo "OrientDB server not shutting down..." >&2; exit 2)
	done
    fi
    orientdb start > /dev/null

    # TODO: Hackish; try connect to server instead.
    sleep 4

    echo "Creating core schema..."
    SCHEMA_ODB="${home}/.conveyor/data/dogfoodsoftware.com/conveyor-orientdb/schema/conveyor.odb"
    mkdir -p `dirname "$SCHEMA_ODB"`
    cp "${src}/schema/conveyor.odb" "${SCHEMA_ODB}"
    for VAR in '${ODB_USERNAME}' '${ODB_PASSWORD}'; do
	# TODO: I thought in place replacement worked, but it seemed to
	# produce errors and I didn't have time to look into it.
	VAR_VALUE=`eval echo "$VAR"`
	mv "$SCHEMA_ODB" "$SCHEMA_ODB".tmp
	sed -e "s|${VAR}|${VAR_VALUE}|" "${SCHEMA_ODB}.tmp" > "$SCHEMA_ODB"
	rm "$SCHEMA_ODB".tmp
    done

    # 'orientdb-console' will exit with non-0 even if everything fine. (2.0-RC1)
    orientdb-console "$SCHEMA_ODB" || true

elif [[ ! -f "$ODB_CREDENTIALS" ]]; then
    echo "ERROR: Found Conveyor (Orient)DB, but did not find '$ODB_CREDENTIALS'; no automated fix available." >&2
    exit 2 
fi

rm -f $CC_DOCUMENTATION/runtime
ln -s $RUNTIME $CC_DOCUMENTATION/runtime
# TODO: replace this with documentation mount request; also, make
# recursive, creating hard dirs and soft file links.
mkdir -p $CC_DOCUMENTATION/help
for i in `ls $INSTALL_DIR/documentation/help`; do
    if [ -f "$INSTALL_DIR/documentation/help/$i" ]; then
	rm -f "$CC_DOCUMENTATION/help/$i"
	ln -s "$INSTALL_DIR/documentation/help/$i" "$CC_DOCUMENTATION/help/$i"
    fi
done

mkdir $out/bin
ln -s $out/conveyor-core/bin/con $out/bin/con
