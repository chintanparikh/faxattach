server 'faxattach.myaidin.site', :app, :web, :primary => true
set :rails_env, :development
set :scm, :none
set :repository, '.'
set :deploy_via, :copy