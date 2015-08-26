#!/bin/sh

# This script uses MySQL::Sandbox to perform a fresh install of MySQL
# from a tarball, and then try to start it with each of the 
# configuration files in this project.

MYSQL_55_BINARY="mysql-5.5.45-osx10.9-x86_64.tar.gz"
MYSQL_56_BINARY="mysql-5.6.26-osx10.9-x86_64.tar.gz"
MYSQL_57_BINARY="mysql-5.7.8-rc-osx10.9-x86_64.tar.gz"

CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd $CURRENT_DIR

echo "Cleaning tmp dir..";
rm -rf tmp/*

echo "== Testing MySQL 5.5 configuration files ==";

for FILE in `ls $CURRENT_DIR/../mysql-55`; do
 echo "Running ./test-config-file.sh $MYSQL_55_BINARY $CURRENT_DIR/../mysql-55/$FILE";
 ./test-config-file.sh $MYSQL_55_BINARY $CURRENT_DIR/../mysql-55/$FILE  2>&1 | grep -E 'PASS|FAIL'
done;

echo "== Testing MySQL 5.6 configuration files ==";

for FILE in `ls $CURRENT_DIR/../mysql-56`; do
 echo "Running ./test-config-file.sh $MYSQL_56_BINARY $CURRENT_DIR/../mysql-56/$FILE"
 ./test-config-file.sh $MYSQL_56_BINARY $CURRENT_DIR/../mysql-56/$FILE 2>&1 | grep -E 'PASS|FAIL'
done;

echo "== Testing MySQL 5.7 configuration files ==";

# MySQL 5.7 uses a different bootstrap process (i.e. new mysql_install_db).
# It will complain if the datadir is not empty, and this needs to be wiped
# before each test is run :(

for FILE in `ls $CURRENT_DIR/../mysql-57`; do
 echo "Running ./test-config-file.sh $MYSQL_57_BINARY $CURRENT_DIR/../mysql-57/$FILE"

 # MySQL 5.7 uses a different bootstrap process (i.e. new mysql_install_db).
 # It will complain if the datadir is not empty, and this needs to be wiped
 # before each test is run :(
 # Hack:

 rm -rf tmp/msb_5_7_*
 ./test-config-file.sh $MYSQL_57_BINARY $CURRENT_DIR/../mysql-57/$FILE 2>&1 | grep -E 'PASS|FAIL'

done;

