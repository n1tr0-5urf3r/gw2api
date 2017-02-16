# gw2api
Various bash scripts for gw2api

## Requirements
  - jq (from repository)

## Daily Script
currently displays PvE, PvP and WvW Dailies as HTML formatted text

## How to use:
simply clone the repository to /opt and run gw2dailies.sh
run /opt/gw2api/gw2dailies.sh >> /path/to/webserverfile.html to upload it to your webserver

You can also place it in crontab like:
00 03 * * * /usr/local/bin/gw2dailies.sh >> /var/www/html/gw2/dailies.html

## Troubleshooting:
Currently all daily PvE Achievements get fetched, some are only up to lvl 79 so you mostly won't see them ingame.

## Suggestions?
Let me know
