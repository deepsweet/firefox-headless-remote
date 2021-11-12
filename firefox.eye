ROOT = File.expand_path(File.dirname(__FILE__))

Eye.config do
  logger "#{ROOT}/eye.log"
end

Eye.application :firefox do
  working_dir ROOT
  trigger :flapping, times: 10, within: 1.minute
  # currently we do not want monitor the cpu it is only for logs
  check :cpu, every: 30, below: 10000, times: 6

  process :marionette do
    pid_file 'marionette.pid'
    stdall '/dev/null'
    daemonize true

    start_command "/usr/bin/firefox-dev -headless -marionette -profile /home/firefox/profile/"

    stop_signals [:TERM, 5.seconds, :KILL]
    restart_command 'kill -USR2 {PID}'

    # just sleep this until process get up status
    # (maybe enought to firefox soft restart)
    restart_grace 5.seconds

    check :memory, every: 30, below: 350.megabytes, times: [3, 5]
    # with option below will calculate all children memory and kill marionette process
    # check :children_memory, every: 15, below: 450.megabytes, times: [3, 5]

    monitor_children do
      stop_command 'kill -QUIT {PID}'
      # with option below will calculate each child memory and kill child process
      check :memory, every: 10, below: 200.megabytes, times: [3, 5]
    end
  end
end
