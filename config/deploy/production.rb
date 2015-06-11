# -*- encoding : utf-8 -*-
server 'hedra.com.br', :app, :web, :db, :primary => true
set :deploy_to, "/home/deploy/apps/hedrasite"
after "deploy:update", "newrelic:notice_deployment"
set :branch, 'master'
