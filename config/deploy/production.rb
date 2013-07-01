server 'faxattach.myaidin.com', :app, :web, :primary => true
set :rails_env, :production
set :scm, :git
set :repository, 'git@github.com:chintanparikh/faxattach.git'
set :deploy_via, :remote_cache
