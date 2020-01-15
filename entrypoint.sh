
#!/bin/sh

if [ "$(ls -A /home/firefox/.fonts/)" ]; then
  fc-cache -f -v
fi

echo "user_pref(\"marionette.port\", $MARIONETTE_PORT);"
echo "user_pref(\"marionette.port\", $MARIONETTE_PORT);" >> /home/firefox/profile/prefs.js

ip=$(hostname --ip-address)

socat tcp-listen:$MARIONETTE_PORT,bind="$ip",fork tcp:127.0.0.1:$MARIONETTE_PORT &

/usr/bin/firefox -headless -marionette -safe-mode -profile /home/firefox/profile/