#!/bin/bash

/usr/bin/ckan --config=/srv/app/ckan.ini report initdb
/usr/bin/ckan --config=/srv/app/ckan.ini archiver init
/usr/bin/ckan --config=/srv/app/ckan.ini qa init

# Make a directory for supervisor and cron logs
mkdir -p /srv/app/report_logs

# Start the supervisor tasks
supervisorctl reread
supervisorctl add ckan_worker_priority
supervisorctl add ckan_worker_bulk
supervisorctl start ckan_worker_priority
supervisorctl start ckan_worker_bulk

# Start crond (Already started on harvest setup)
# /usr/sbin/crond start

# Create cron job to run 'report generate broken-links' command (every 06:00)
( crontab -l ; echo "0 6 * * * /usr/bin/ckan -c /srv/app/ckan.ini report generate broken-links >> /srv/app/report_logs/report.log 2>&1" ) | crontab -

# Create cron job to run 'report generate openness' command (every 00:00)
( crontab -l ; echo "0 0 * * * /usr/bin/ckan -c /srv/app/ckan.ini report generate openness >> /srv/app/report_logs/report.log 2>&1" ) | crontab -

# Create cron job to run 'archiver update' command (every 03:00 on sunday)
( crontab -l ; echo "0 3 * * 0 /usr/bin/ckan -c /srv/app/ckan.ini archiver update -q bulk >> /srv/app/report_logs/archiver.log 2>&1" ) | crontab -
