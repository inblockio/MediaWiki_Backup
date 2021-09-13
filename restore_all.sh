#!/usr/bin/env bash

set -e
archive_file=2021-09-12-mediawiki_backup.tar.gz

# Extract tarball and restore images
docker exec -it micro-pkc_mediawiki_1 /MediaWiki_Backup/extract_and_restore_images.sh -a "/backup/$archive_file" -w /var/www/html

# Restore database
docker exec -it micro-pkc_database_1 /MediaWiki_Backup/restore_database.sh /backup/database.sql.gz
# Clean up database sql file
docker exec -it micro-pkc_database_1 rm /backup/database.sql.gz

# Toggle read-only off
docker exec -it micro-pkc_mediawiki_1 source /MediaWiki_Backup/toggle_read_only_off.sh /var/www/html
