#!/bin/bash
#Sync Folders in nextcloud
#This script can be set as Userlogon- and Logoff-script in your display manager
#e.g. if you use sddm and kde/plasma5 you may specify it in autostart/system settings
#
# for logoff use "Add script" to this script and select logoff as executiontime
# for logon use "Add program" an make the terminal stay open
#
logfile=~/nextcloudcmd_sync.log # Logfile-Name
protocol="https://" # https:// or http://
localprofile=~/.mozilla # set to local path (~ needs to be without ")
serverpath="@server.com/nextcloud/remote.php/webdav/directorytosync" #@server/webpath to profile in nextcloud
username="user123"
password="xxx"
colon=":" #no need to change
#Main
cd "$localprofile"
echo "Syncing $localprofile with $serverpath"
#Set me to only user readable (passwords are here, file is synced world readable)
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
    exit 1
fi
echo "Last Sync via $0 at" > "$logfile"
date >> "$logfile"
nextcloudcmd --trust -h $localprofile $protocol$username$colon$password$serverpath >> "$logfile" 2>&1
echo "Sync finished. You may close window if it does not automatic."
