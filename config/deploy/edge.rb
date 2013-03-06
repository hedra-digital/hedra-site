server '198.211.106.172', :app, :web, :db, :primary => true
set :deploy_to, "/home/deploy/apps/hedra-site"
set(:rails_env) { "production" }
