#!/usr/bin/env bash

set -e

SQLFILE=$1

## Includes functions.sh to get access to its functions
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$DIR/functions.sh"

MYSQL_USERNAME=wikiuser
MYSQL_PASSWORD=example

DB_HOST=localhost
DB_NAME=my_wiki
DB_USER=wikiuser
DB_PASS=example

# First we drop the existing database
mysql -u $DB_USER --password=$DB_PASS --host=$DB_HOST -e "DROP DATABASE IF EXISTS $DB_NAME"

restore_database
restore_user
restore_database_content
