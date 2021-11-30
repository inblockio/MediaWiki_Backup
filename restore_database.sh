#!/usr/bin/env bash
#
# Copyright Sam Wilson 2013 CC-BY-SA
# http://creativecommons.org/licenses/by-sa/3.0/au/
#

set -e

################################################################################
## MySQL wiki database and user creation

function execute_sql {
    SQL_STATEMENT=$1
    echo "Executing statement : '$SQL_STATEMENT'"
    echo $SQL_STATEMENT | mysql -u $MYSQL_USERNAME --password=$MYSQL_PASSWORD --host=$DB_HOST 
}
  
function restore_database {
    execute_sql "create database $DB_NAME;"
}

#Information taken from here http://www.mediawiki.org/wiki/Manual:Installation/Creating_system_accounts
#Compared to show grants for '$user'@host, which showed that 'WITH GRANT OPTION' was not set by the original installation in version 1.17
# \note the % system is any IP, but does not work for localhost ! see http://stackoverflow.com/questions/10823854/using-for-host-when-creating-a-mysql-user
function restore_user {
    execute_sql "grant all privileges on $DB_NAME.* to $DB_USER@localhost.localdomain identified by '$DB_PASS';"
    execute_sql "grant all privileges on $DB_NAME.* to $DB_USER@localhost identified by '$DB_PASS';"
    execute_sql "grant all privileges on $DB_NAME.* to $DB_USER@'%' identified by '$DB_PASS';"
}

################################################################################
## Database restoration
function restore_database_content {
    if [ -z $DB_NAME ]; then
        echo "No database was found, cannot restore sql dump."
        return 1
    fi

    echo "Restoring database '$DB_NAME' from file $SQLFILE" 
    gunzip -c $SQLFILE | mysql -u $MYSQL_USERNAME --password=$MYSQL_PASSWORD --host=$DB_HOST $DB_NAME
}

# The ain procedure
SQLFILE=$1

MYSQL_USERNAME=wikiuser
MYSQL_PASSWORD=example

DB_HOST=localhost
DB_NAME=my_wiki
DB_USER=wikiuser
DB_PASS=example

# We deviate from the original code by not dropping the database. Instead, we
# drop the tables in the database. And so we don't need to recreate the
# database.
# First we drop the existing tables in the database
echo "SELECT concat('DROP TABLE IF EXISTS \\\`', table_name, '\\\`;') FROM information_schema.tables WHERE table_schema = '$DB_NAME';" | mysql -B -N -u $DB_USER --password=$DB_PASS --host=$DB_HOST | mysql -u $DB_USER --password=$DB_PASS --host=$DB_HOST $DB_NAME

# restore_database
# restore_user
restore_database_content
