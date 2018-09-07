#!/bin/sh

if [ "$(ls -A /home/firefox/.fonts/)" ]; then
  fc-cache -f -v
fi

ip=$(hostname --ip-address)

socat tcp-listen:2828,bind="$ip",fork tcp:127.0.0.1:2828 &

/usr/bin/firefox -headless -marionette -safe-mode -profile /home/firefox/profile/
