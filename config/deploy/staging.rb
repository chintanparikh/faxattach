server 'faxattach-staging-new', :app, :web, :primary => true
set :rails_env, :staging
set :scm, :git
set :repository, 'git@github.com:chintanparikh/faxattach.git'
