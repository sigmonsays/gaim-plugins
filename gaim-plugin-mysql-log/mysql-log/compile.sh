#!/bin/bash

PLUGIN_CFLAGS="-I/usr/local/mysql/include/"
PLUGIN_LIBS="-lmysqlclient -L/usr/local/mysql/lib/mysql"
export PLUGIN_CFLAGS PLUGIN_LIBS

rm -f mysql-log.so
make mysql-log.so
cp mysql-log.so /usr/local/lib/gaim
