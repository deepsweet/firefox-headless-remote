God.watch do |w|
  w.name = "Firefox"
  w.start = "/usr/bin/firefox-dev -headless -marionette -profile /home/firefox/profile/"
  w.keepalive
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.interval = 20
      c.above = ENV.fetch("FF_MEM_LIMIT", "500").to_i.megabytes
      c.times = [3, 5]
    end
  end
end
