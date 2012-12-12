server "hedra.com.br", :app, :web, :db, :primary => true
set :deploy_to, "/home/deploy/apps/staging"
set :rails_env, "staging"
