# nextcloud_sync.sh
Script to sync Nextcloud- Folders via CLI-Client.

## Why?
I searched for a Solution to sync my Firefox-Profile between different PCs to always have the same look and Settings and also for a Backup- Solution. I found a good way to sync it to my Nextcloud- Server, but integrating it in the client, caused troubles when running firefox and the client trying to sync each accessed file on the fly.

## What to do?
So i made this script, placed my credentials and local Firefox-Profile (~./mozilla) and Serverpath in it and embedded it into KDE-Logon and Logoff. At Logon i choose to leave the terminal open to remind me that it worked.

## Features
1. This script checks if the server is reachable first. This is needed for wireless-connections running on networkmanager-managed networks, where it can take a bit time to establish the link.
2. The results are logged in the logfile specified in the script
