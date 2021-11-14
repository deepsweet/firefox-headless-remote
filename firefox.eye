ROOT = File.expand_path(File.dirname(__FILE__))

Eye.config do
  logger syslog
end

Eye.application :firefox do
  working_dir ROOT
  trigger :flapping, times: 10, within: 1.minute
  # currently we do not want limit the cpu it is only for logs
  check :cpu, every: 30, below: 1000, times: 6

  process :marionette do
    pid_file 'marionette.pid'
    stdall '/dev/null'
    daemonize true

    # start_command "/home/damir/firefox/developer-firefox/firefox-bin -marionette -profile /home/damir/firefox/profile_2/"
    start_command "/usr/bin/firefox-dev -headless -marionette -profile /home/firefox/profile/"

    stop_signals [:TERM, 5.seconds, :KILL]
    restart_command 'kill -USR2 {PID}'

    # just sleep this until process get up status
    # (maybe enought to firefox soft restart)
    restart_grace 5.seconds

    # main process
    check :memory, every: 30, below: 300.megabytes, times: [4, 4]
    # with option below will calculate all children memory and kill marionette process
    check :children_memory, every: 30, below: 500.megabytes, times: [4, 4]

    monitor_children do
      children_update_period 5.seconds
      # with option below will calculate each child memory and send kill command
      check :memory, every: 10, below: 350.megabytes, times: [6, 6]
      # currently we do not want limit the cpu it is only for logs
      check :cpu, every: 15, below: 1000, times: 5

      # Stop with kill child
      stop_command 'kill -QUIT {PID}'

      # Stop with kill parent
      # stop_command 'kill -USR2 {PARENT_PID}'
    end
  end
end
