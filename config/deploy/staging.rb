server 'faxattach.staging.myaidin.com', :app, :web, :primary => true
set :rails_env, :staging
set :scm, :git
set :repository, 'git@github.com:chintanparikh/faxattach.git'
set :deploy_via, :remote_cache
