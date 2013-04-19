server "staging.hedra.com.br", :app, :web, :db, :primary => true
set :deploy_to, "/home/deploy/apps/hedrasite_staging"
set(:rails_env) { "#{stage}" }
