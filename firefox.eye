ROOT = File.expand_path(File.dirname(__FILE__))

Eye.config do
  logger "#{ROOT}/eye.log"
end

Eye.application :firefox do
  working_dir ROOT
  trigger :flapping, times: 10, within: 1.minute

  process :marionette do
    daemonize true
    pid_file 'marionette.pid'
    stdall 'marionette.log'

    start_command "/usr/bin/firefox-dev -headless -marionette -profile /home/firefox/profile/"

    stop_signals [:TERM, 5.seconds, :KILL]
    restart_command 'kill -USR2 {PID}'

    # just sleep this until process get up status
    # (maybe enought to firefox soft restart)
    restart_grace 5.seconds

    # currently we not monitor the cpu
    # check :cpu, every: 30, below: 90, times: 3

    check :memory, every: 30, below: 800.megabytes, times: [3, 5]
  end
end
