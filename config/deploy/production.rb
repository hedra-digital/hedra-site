server "hedra.com.br", :app, :web, :db, :primary => true
set :deploy_to, "/home/deploy/apps/hedra-site"
after "deploy:update", "newrelic:notice_deployment"
