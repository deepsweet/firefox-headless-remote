#!/bin/sh

if [ "$(ls -A /home/firefox/.fonts/)" ]; then
  fc-cache -f -v
fi

echo "user_pref(\"marionette.port\", $MARIONETTE_PORT);"
echo "user_pref(\"marionette.port\", $MARIONETTE_PORT);" >> /home/firefox/profile/prefs.js

/usr/bin/firefox -headless -marionette -profile /home/firefox/profile/
