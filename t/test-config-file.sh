#!/bin/sh

MYSQL_BINARY=$1
FILE=$2

CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# make sandbox bootstrap here.
export SANDBOX_HOME="$CURRENT_DIR/tmp";

# The MySQL::Sandbox -f and -m flags don't seem to work
# Quite as expected, so I am going to bootstrap the instance,
# then add the config file, then restart it.

make_sandbox $MYSQL_BINARY -- --force --no_show --no_run | tee  /tmp/msandbox.out
SANDBOX_DIR=`tail -n1 /tmp/msandbox.out | awk '{ print $NF }'`
eval cd $SANDBOX_DIR

# Backup my.sandbox.cnf
cp my.sandbox.cnf my.sandbox.cnf-dist
FILE_ESC=${FILE//\//\\\/}

# Patch my.sandbox.cnf to use an !include, as this project is aimed to be used as.
perl -pi -e "s/^\[mysqld\]$/[mysqld]\n!include $FILE_ESC/g" my.sandbox.cnf

# Try starting it.
# @TODO: Capture a complete log file.
./start && echo "[PASS] $FILE" || echo "[FAIL] $FILE"

# Stop and destroy?
./stop

