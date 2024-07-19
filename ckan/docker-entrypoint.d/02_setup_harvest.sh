#!/bin/bash

# Create the necessary tables in the database
/usr/bin/ckan --config=/srv/app/ckan.ini db upgrade -p harvest

# Make a directory for supervisor and cron logs
mkdir -p /srv/app/harvest_logs

# Start the supervisor tasks
supervisorctl reread
supervisorctl add ckan_gather_consumer
supervisorctl add ckan_fetch_consumer
supervisorctl start ckan_gather_consumer
supervisorctl start ckan_fetch_consumer

# Start crond
/usr/sbin/crond start

# Create cron job to run 'harvester run' command (every 15 minutes)
( crontab -l ; echo "*/15 * * * * /usr/bin/ckan -c /srv/app/ckan.ini harvester run >> /srv/app/harvest_logs/run.log 2>&1" ) | crontab -
