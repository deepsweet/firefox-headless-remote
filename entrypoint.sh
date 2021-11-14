#!/bin/sh

if [ "$(ls -A /home/firefox/.fonts/)" ]; then
  fc-cache -f -v
fi

echo "user_pref(\"marionette.port\", $MARIONETTE_PORT);"
echo "user_pref(\"marionette.port\", $MARIONETTE_PORT);" >> /home/firefox/profile/prefs.js

ip=$(hostname --ip-address)

socat tcp-listen:$MARIONETTE_PORT,bind="$ip",fork tcp:127.0.0.1:$MARIONETTE_PORT &

# Load eye confing and run marionette
eye l /home/firefox/firefox.eye
# Tracing eye log to stdout
# disabled because we use syslog driver
# tail -f /var/log/syslog | grep eye
while true ; do sleep 10 && eye i -jp ; done
