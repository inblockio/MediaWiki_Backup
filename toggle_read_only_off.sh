#!/usr/bin/env bash

# We cannot use set -e because toggle_read_only sometimes has an exit status 1
# and needs to continue.
#set -e

INSTALL_DIR=$1

## Includes backup.sh to get access to its functions
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$DIR/backup.sh"

get_localsettings_vars

# The backup procedure would save LocalSettings in read-only mode
toggle_read_only OFF
