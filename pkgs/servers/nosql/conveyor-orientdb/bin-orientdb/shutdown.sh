#!/bin/bash
#
# Copyright (c) Orient Technologies LTD (http://www.orientechnologies.com)
#
# HISTORY:
# 2012-07-31: Added -w option
#

# resolve links - $0 may be a softlink
PRG="$0"

if [ $# -gt 0 ]; then
  case "$1" in
    -w|--wait)
      wait="yes"
      shift 1 ;;
  esac
fi


# The original had logic here to find the 'ORIENTDB_HOME' path. In the
# Conveyor setup, that's clearly specified so we've cut it all
# out. These runtime settings never need change.
ORIENTDB_HOME="$HOME/.conveyor/runtime/dogfoodsoftware.com/conveyor-orientdb"
CONFIG_FILE="$ORIENTDB_HOME/config/orientdb-server-config.xml"
LOG_FILE="$ORIENTDB_HOME/config/orientdb-server-log.properties"

if [ -f "${JAVA_HOME}/bin/java" ]; then 
   JAVA=${JAVA_HOME}/bin/java
else
   JAVA=java
fi
export JAVA

LOG_LEVEL=warning
WWW_PATH=$ORIENTDB_HOME/www
JAVA_OPTS=-Djava.awt.headless=true

"$JAVA" -client $JAVA_OPTS -Dorientdb.config.file="$CONFIG_FILE" -cp "$ORIENTDB_HOME/lib/orientdb-tools-2.0-rc1.jar:$ORIENTDB_HOME/lib/*" com.orientechnologies.orient.server.OServerShutdownMain $*

if [ "x$wait" = "xyes" ] ; then
  while true ; do
    ps -ef | grep java | grep $ORIENTDB_HOME/lib/orientdb-server > /dev/null || break
    sleep 1;
  done
fi
