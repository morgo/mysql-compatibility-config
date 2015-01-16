# mysql-compatibility-config

Make MySQL behave more like newer (or older) releases of MySQL.

## Usage

The initial path i.e. `mysql-57/` refers to the current version that you have installed.  Inside that path are one or more compatibility file options.

For example, if I want to make my MySQL 5.7 server behave like MySQL 5.6, I would download `mysql-57/mysql-56.cnf` and add it to `/etc/my.cnf` **directly** under the `[mysqld]` option heading:

     [mysqld]
     !include /etc/mysql-56.cnf
     
     /* your other options appear below */
