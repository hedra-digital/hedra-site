# -*- encoding : utf-8 -*-
require 'bundler/capistrano'
require 'capistrano/ext/multistage'
require 'new_relic/recipes'

set :stages, ["staging", "production", "edge"]
set :default_stage, "staging"

set :application, "Hedra Site"

set :deploy_via, :remote_cache

set :scm, :git
set :repository,  "https://github.com/hedra-digital/hedra-site.git"
set :user, 'deploy'

ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "livrodaclasse_rsa"), File.join(ENV["HOME"], ".ssh", "id_rsa")]

set :use_sudo, false
set :keep_releases, 3

default_run_options[:pty] = true

after 'deploy:update_code', 'deploy:symlink_config_file', 'deploy:symlink_uploads', 'deploy:copy_old_sitemap'
after 'deploy:update', 'deploy:cleanup'
after "deploy", "deploy:migrate"

namespace :deploy do
  desc "Symlinks the config file"
  task :symlink_config_file, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/config/config.yml #{release_path}/config/config.yml"
  end

  desc "Symlinks the uploads directory"
  task :symlink_uploads, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/public/uploads #{release_path}/public/uploads"
    run "ln -nfs #{deploy_to}/shared/private #{release_path}/private"
  end

  task :copy_old_sitemap do
    run "if [ -e #{previous_release}/public/sitemap_index.xml.gz ]; then cp #{previous_release}/public/sitemap* #{current_release}/public/; fi"
  end

  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
