worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 15
preload_app true

#listen "/tmp/unicorn.sock"
listen 3333 #"/tmp/unicorn.sock"
pid "/tmp/unicorn.pid"

stderr_path File.expand_path('log/unicorn.log', ENV['RAILS_ROOT'])
stdout_path File.expand_path('log/unicorn-error.log', ENV['RAILS_ROOT'])
working_directory "/home/skoba/src/upki-tools"
