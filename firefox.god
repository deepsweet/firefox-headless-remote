God.watch do |w|
  w.name = "Firefox"
  w.start = "/usr/bin/firefox -headless -marionette -safe-mode -profile /home/firefox/profile/"
  w.keepalive
end