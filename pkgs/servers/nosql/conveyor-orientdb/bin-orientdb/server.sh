#!/bin/sh
#
# Copyright (c) Orient Technologies LTD (http://www.orientechnologies.com)
#

echo "           .                                          "
echo "          .\`        \`                                 "
echo "          ,      \`:.                                  "
echo "         \`,\`    ,:\`                                   "
echo "         .,.   :,,                                    "
echo "         .,,  ,,,                                     "
echo "    .    .,.:::::  \`\`\`\`                                 :::::::::     :::::::::   "
echo "    ,\`   .::,,,,::.,,,,,,\`;;                      .:    ::::::::::    :::    :::  "
echo "    \`,.  ::,,,,,,,:.,,.\`  \`                       .:    :::      :::  :::     ::: "
echo "     ,,:,:,,,,,,,,::.   \`        \`         \`\`     .:    :::      :::  :::     ::: "
echo "      ,,:.,,,,,,,,,: \`::, ,,   ::,::\`   : :,::\`  ::::   :::      :::  :::    :::  "
echo "       ,:,,,,,,,,,,::,:   ,,  :.    :   ::    :   .:    :::      :::  :::::::     "
echo "        :,,,,,,,,,,:,::   ,,  :      :  :     :   .:    :::      :::  :::::::::   "
echo "  \`     :,,,,,,,,,,:,::,  ,, .::::::::  :     :   .:    :::      :::  :::     ::: "
echo "  \`,...,,:,,,,,,,,,: .:,. ,, ,,         :     :   .:    :::      :::  :::     ::: "
echo "    .,,,,::,,,,,,,:  \`: , ,,  :     \`   :     :   .:    :::      :::  :::     ::: "
echo "      ...,::,,,,::.. \`:  .,,  :,    :   :     :   .:    :::::::::::   :::     ::: "
echo "           ,::::,,,. \`:   ,,   :::::    :     :   .:    :::::::::     ::::::::::  "
echo "           ,,:\` \`,,.                                  "
echo "          ,,,    .,\`                                  "
echo "         ,,.     \`,                                          GRAPH DATABASE  "
echo "       \`\`        \`.                                                          "
echo "                 \`\`                                         www.orientdb.org "
echo "                 \`                                    "

# The original had logic here to find the 'ORIENTDB_HOME' path. In the
# Conveyor setup, that's clearly specified so we've cut it all
# out. These runtime settings never need change.
ORIENTDB_HOME="$HOME/.conveyor/runtime/dogfoodsoftware.com/conveyor-orientdb"
CONFIG_FILE="$ORIENTDB_HOME/config/orientdb-server-config.xml"
LOG_FILE="$ORIENTDB_HOME/config/orientdb-server-log.properties"
# Runtime settings that can change are loaded from the package data.
source $HOME/.conveyor/data/dogfoodsoftware.com/conveyor-orientdb/conf/server-config.sh
MAXHEAP="-Xmx${MAXHEAP}"

cd "$ORIENTDB_HOME"

# The 'real' config file is under the Conveyor data dir for
# 'conveyor-orientdb'. However, we link the original config directory
CONFIG_FILE=$ORIENTDB_HOME/config/orientdb-server-config.xml

# Raspberry Pi check (Java VM does not run with -server argument on ARMv6)
if [ `uname -m` != "armv6l" ]; then
  JAVA_OPTS="$JAVA_OPTS -server "
fi
export JAVA_OPTS

# Set JavaHome if it exists
if [ -f "${JAVA_HOME}/bin/java" ]; then 
   JAVA=${JAVA_HOME}/bin/java
else
   JAVA=java
fi
export JAVA


WWW_PATH=$ORIENTDB_HOME/www
ORIENTDB_SETTINGS="-Dprofiler.enabled=true"
JAVA_OPTS_SCRIPT="-Djna.nosys=true -XX:+HeapDumpOnOutOfMemoryError -Djava.awt.headless=true -Dfile.encoding=UTF8 -Drhino.opt.level=9"

echo "Start with:"
echo "$JAVA" $JAVA_OPTS $MAXHEAP $JAVA_OPTS_SCRIPT $ORIENTDB_SETTINGS $MAXDISKCACHE -Djava.util.logging.config.file="$LOG_FILE" -Dorientdb.config.file="$CONFIG_FILE" -Dorientdb.www.path="$WWW_PATH" -Dorientdb.build.number="UNKNOWN@r${buildNumber}; 2014-12-17 21:54:12+0000" -DCONVEYOR_DATA_DIR="$HOME/.conveyor/data/dogfoodsoftware.com/conveyor-orientdb" -cp "$ORIENTDB_HOME/lib/orientdb-server-2.0-rc1.jar:$ORIENTDB_HOME/lib/*" $* com.orientechnologies.orient.server.OServerMain
echo

"$JAVA" $JAVA_OPTS $MAXHEAP $JAVA_OPTS_SCRIPT $ORIENTDB_SETTINGS $MAXDISKCACHE -Djava.util.logging.config.file="$LOG_FILE" -Dorientdb.config.file="$CONFIG_FILE" -Dorientdb.www.path="$WWW_PATH" -Dorientdb.build.number="UNKNOWN@r${buildNumber}; 2014-12-17 21:54:12+0000" -DCONVEYOR_DATA_DIR="$HOME/.conveyor/data/dogfoodsoftware.com/conveyor-orientdb" -cp "$ORIENTDB_HOME/lib/orientdb-server-2.0-rc1.jar:$ORIENTDB_HOME/lib/*" $* com.orientechnologies.orient.server.OServerMain
