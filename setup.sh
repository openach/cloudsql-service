#!/bin/bash

CLOUDSQL_HOME=/opt/cloudsql

echo "Downloading cloud_sql_proxy to $CLOUDSQL_HOME."
mkdir -p $CLOUDSQL_HOME
wget -O $CLOUDSQL_HOME/cloud_sql_proxy https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64
chmod +x $CLOUDSQL_HOME/cloud_sql_proxy

echo "Installing default config and init.d script for automatic startup."
cp etc/init.d/cloudsql /etc/init.d/cloudsql
mkdir -p /etc/cloudsql/

if [ -f /etc/cloudsql/cloudsql.conf ]
then
    cp etc/cloudsql/cloudsql.conf /etc/cloudsql/cloudsql.conf.dist
    echo "Config file exists at /etc/cloudsql/cloudsql.conf."
    echo "Copying new config to /etc/cloudsql/cloudsql.conf.dist"
else
    cp etc/cloudsql/cloudsql.conf /etc/cloudsql/cloudsql.conf
fi

chkconfig --add cloudsql
chkconfig cloudsql on

echo <<EOD
Google Cloud SQL Proxy installed in $CLOUDSQL_HOME.

!!!! Be sure to update /etc/cloudsql/cloudsql.conf before running cloudsql!

You can control Google Cloud SQL Proxy through the init.d service tool:

START Cloud SQL:	service cloudsql start
STOP Cloud SQL:		service cloudsql stop
UNINSTALL Service:	service cloudsql uninstall

Cloud SQL will log to /var/log/cloudsql.log

EOD
