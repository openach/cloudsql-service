# Google Cloud SQL Proxy init.d Service
Google Cloud provides a proxy connector that allows you to connect a MySQL client to your Google Cloud SQL instance.  It works great, but doesn't come in a daemon-friendly form.  We put together this install script and init.d service script to make it a bit easier to manage on an Ubuntu server.  ([Learn more about LSB init scripts](http://wiki.debian.org/LSBInitScripts)).

To learn more about Google Cloud SQL Proxy, [check out Google's documentation](https://cloud.google.com/sql/docs/mysql-connect-proxy).

## Installing
Clone this repo (or download the archive):
```sh
$ git clone https://github.com/openach/cloudsql-service
$ cd cloudsql-service
$ ./setup.sh
```
This will perform the following:
  - Download the latest cloud_sql_proxy directly from Google to /opt/cloudsql/
  - Create a default config file in /etc/cloudsql/cloudsql.conf
  - Install a cloudsql service script at /etc/init.d/cloudsql

## Configuration
As outlined in the Google Cloud SQL Proxy instructions, you will need to set up credentials to enable you to remotely access Google Cloud SQL from your server.  The configuration requires you have a JSON-formatted private key credential file.  This file will need to be copied to a secure location somewhere on your server.  We recommend /etc/cloudsql/:
```sh
$ cp your-credential-file.json /etc/cloudsql/
$ chmod 600 /etc/cloudsql/your-credential-file.json
```
Then, edit the configuration file located at /etc/cloudsql/cloudsql.conf, using your favorite editor.  Specifically pay attention to the following settings:
```sh
# Local port to open for MySQL connections. This can be either a port or ipaddress:port
# If you use an IP address, ensure that your firewall is blocking outside traffic!
MYSQL_PORT=3306

# Instance ID to which the proxy should connect
INSTANCE_ID=your:googlecloudsql:instanceid

# Credential file to use for the connection - FULL PATH REQUIRED!
CREDENTIAL_FILE=/full/path/to/your/credential.json
```
Note: The cloudsql.conf file is actually a Bash-formatted script, sourced by init.d/cloudsql.  Hack away!

## Running Cloud SQL Proxy
As with any init.d service, you can simply use the "service" command to start, stop or restart cloud_sql_proxy:
```sh
$ service cloudsql start
$ service cloudsql stop
$ service cloudsql restart
```

## Cloud SQL Proxy Logging
The service will log all the output from cloud_sql_proxy to /var/log/cloudsql.log.

## Uninstalling the init.d Script
To uninstall the service, simply run:
```sh
$ service cloudsql uninstall
```
Note that the cloud_sql_proxy will remain in /opt/cloudsql/, and your config will still be in /etc/cloudsql/.  You will need to remove these manually, along with any logs in /var/log/.

## Issues?
If you have any issues with the script, feel free to open an issue on this project.  We probably won't respond immedaitely, but we will keep an eye out for issues.

### As Is, No Warranty
You know the drill.  We're not responsible for what this script does to your server.  Use it at your own risk.  It hasn't blown up any of our own servers, but you never know.  With artificial intelligence on the rise, it's probably just a matter of time. :)

### A HUGE "Thank You" to...
We would like to give a HUGE thank you to Nicolas Chambrier (naholyr on GitHub), who has an LSB Init script template that we used as the basis for the Google Cloud SQL Proxy startup script.  Credit where credit is due.  You rock, dude!  Check out his LSB init script template here: https://gist.github.com/naholyr/4275302
