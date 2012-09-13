require 'bundler/capistrano'

set :application, "hedra-site"
set :repository,  "git@github.com:hedra-digital/hedra-site.git"

set :scm, :git
set :user, 'deploy'

ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "livrodaclasse_rsa")]

set :use_sudo, false

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/home/deploy/apps/hedra-site"
set :deploy_via, 'copy'

default_run_options[:pty] = true

role :web, "hedra.com.br"                          # Your HTTP server, Apache/etc
role :app, "hedra.com.br"                          # This may be the same as your `Web` server
role :db,  "hedra.com.br", :primary => true      # This is where Rails migrations will run


# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

after 'deploy:update_code', 'deploy:symlink_db'

namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end
end

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

# namespace :deploy do
#   namespace :assets do
#     desc "Precompile assets on local machine and upload them to the server."
#     task :precompile, :roles => :web, :except => { :no_release => true } do
#       run_locally "bundle exec rake assets:precompile"
#       find_servers_for_task(current_task).each do |server|
#         run_locally "rsync -vr --exclude='.DS_Store' public/assets #{user}@#{server.host}:#{shared_path}/"
#       end
#     end
#   end
# end

desc "Run the super-awesome rake task"
task :super_awesome do
  rake = fetch(:rake, 'rake')
  rails_env = fetch(:rails_env, 'production')

  run "cd '#{current_path}' && #{rake} super_awesome RAILS_ENV=#{rails_env}"
end