God.watch do |w|
  w.name = "Firefox"
  w.start = "/usr/bin/firefox-dev -headless --marionette -profile /home/firefox/profile/"
  w.keepalive
end