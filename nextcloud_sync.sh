#!/bin/bash
#Sync some Folder in Batch
#
myidentitiy='Mozilla-Profile' #short Name for this job
logfile=~/nextcloudcmd_sync.log # Logfile-Name
localpath=~/.mozilla # set to path of mozilla (~ needs to be without ")
protocol="https://" # https:// or http://
serverpath="@obel1x.de/owncloud/remote.php/webdav/mozillaprofil_nach_home_.mozilla" #@server/webpath to profile in nextcloud
username="username"
password="password"
colon=":" #no need to change
#Main
cd "$localpath"
echo "Syncing $localpath with $serverpath"
#Set me to only user readable (passwords are here, file is synced from nextcloud "world readable" - not good, so change permissions here!)
chmod 0700 $0
#First check if server ist up, or if to wait
((count = 10))                            # Maximum number to try.
while [[ $count -ne 0 ]] ; do
    curl $protocol$serverpath -k >/dev/null 2>&1 # check if connection is up
    rc=$?
    if [[ $rc -eq 0 ]] ; then
        ((count = 1))                      # If okay, flag to exit loop.
    else
        echo "Server not reached, waiting (countdown $count)."
        sleep 3
    fi
    ((count = count - 1))                  # So we don't go forever.
done
if [[ $rc -eq 0 ]] ; then                  # Make final determination.
    echo "Server is up."
else
    echo "Server offline, giving up."
    notify-send "Nextcloud-Sync $myidentitiy: Server offline, giving up."
    exit 1
fi
#leider lassen sich beide sync-logs nicht in diesen pfad syncen. Grund: wenn ein anderer Rechner offline geht, dabei das log zuletzt
#geschrieben hat, und dieser das log vor Aufruf neu setzt, dann gibt es zwei neue versionen. eine davon ist "conflicting".
#Also aus dem Pfad heraus verschoben.
echo "Last Sync via $0 at" > "$logfile"
date >> $logfile
nextcloudcmd --trust -h $localpath $protocol$username$colon$password$serverpath >> "$logfile" 2>&1
rc=$?
if [[ $rc -eq 0 ]] ; then
    echo "Nextcloud-Sync: finished successful."
    notify-send "Nextcloud-Sync $myidentitiy: Sync finished successful."
else
    echo "Nextcloud-Sync: Error, please check Logfile $logfile"
    notify-send "Nextcloud-Sync $myidentitiy: Error."
fi
