require 'capistrano/ext/multistage'
require 'rvm/capistrano'

set :stages, %w(production staging development)
set :default_stage, "staging"

set :rvm_ruby_string, 'ruby-1.9.3-p327@faxattach'
set :rvm_type, :system

# Bundler tasks
# require 'bundler/capistrano'
set :application, 'faxattach'
set :apikey, 'MHaBUh3Kctz2x500l5LPMFjo9LNLDKfl6EHF69C1Fq2WrIuB66yw6k5xj30dI17IZ'
set :ssh_options, {forward_agent: true}
# do not use sudo
set :use_sudo, false
set(:run_method) { use_sudo ? :sudo : :run }

# # needed to correctly handle sudo password prompt
default_run_options[:pty] = true

set :user, 'faxattach'
set :group, 'faxattach'
set :runner, 'faxattach'

# Where will it be located on the server?
set :deploy_to, "/srv/www/#{application}"
set :unicorn_conf, "#{deploy_to}/current/config/unicorn.rb"
set :unicorn_pid, "#{deploy_to}/shared/pids/unicorn.pid"

# Unicorn control tasks
namespace :deploy do
  task :restart do
    run "if [ -f #{unicorn_pid} ] && [ -e /proc/`cat #{unicorn_pid}` ]; then kill -USR2 `cat #{unicorn_pid}`; else cd #{deploy_to}/current && API_KEY=#{apikey} bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D; fi"
  end
  task :start do
    run "cd #{deploy_to}/current && bundle exec unicorn -c #{unicorn_conf} -E #{rails_env} -D"
  end
  task :end do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end
end
