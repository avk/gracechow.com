set :application, "gracechow.com"
set :runner, "avk"
set :user, "avk"
set :deploy_via, :remote_cache
set :use_sudo, true

# If you have previously been relying upon the code to start, stop 
# and restart your mongrel application, or if you rely on the database
# migration code, please uncomment the lines you require below

# If you are deploying a rails app you probably need these:

# load 'ext/rails-database-migrations.rb'
# load 'ext/rails-shared-directories.rb'

# There are also new utility libaries shipped with the core these 
# include the following, please see individual files for more
# documentation, or run `cap -vT` with the following lines commented
# out to see what they make available.

# load 'ext/spinner.rb'              # Designed for use with script/spin
# load 'ext/passenger-mod-rails.rb'  # Restart task for use with mod_rails
# load 'ext/web-disable-enable.rb'   # Gives you web:disable and web:enable

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"
set :deploy_to, "/home/#{user}/public_html/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
# see a full list by running "gem contents capistrano | grep 'scm/'"
set :scm, :git
set :repository, "git@github.com:avk/gracechow.com.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true
ssh_options[:port] = 8888

role :app, application
role :web, application
role :db, application, :primary => true



after "deploy:setup", "chown"

desc "changes the owner of the root directory"
task :chown do
  run "sudo chown -R #{runner} #{deploy_to}"
end

# from http://archive.jvoorhis.com/articles/2006/07/07/managing-database-yml-with-capistrano
# but modified, because it was from capistrano v1
desc "Create database.yml in shared/config" 
task :after_setup do
  database_configuration = <<-EOF

development:
  adapter: mysql
  encoding: utf8
  database: gracechow_development
  pool: 5
  username: you
  password: pass

test:
  adapter: mysql
  encoding: utf8
  database: gracechow_test
  pool: 5
  username: you
  password: pass

production:
  adapter: mysql
  encoding: utf8
  database: gracechow_production
  pool: 5
  username: you
  password: pass
EOF

  run "mkdir -p #{deploy_to}/#{shared_dir}/config" 
  put database_configuration, "#{deploy_to}/#{shared_dir}/config/database.yml" 
end

desc "Updates the symlink for database.yml file to the just deployed release."
task :after_update_code do
  run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end



before "deploy:restart", "deploy:remove_cached_assets"

# from http://www.zorched.net/2008/06/17/capistrano-deploy-with-git-and-passenger/
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "mkdir -p #{current_path}/tmp"
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Remove cached js and css"
  task :remove_cached_assets do
    run "rm -f #{current_path}/public/stylesheets/cached_*.css"
    run "rm -f #{current_path}/public/javascripts/cached_*.js"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end
