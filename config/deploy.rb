# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'pandify.com'
set :repo_url, 'git@github.com:ustasb/pandify.com.git'

# capistrano/rbenv
set :rbenv_ruby, '2.1.2'

# capistrano/puma
set :puma_workers, 2 # Running on a dual-core machine
set :puma_threads, [1, 16]

set :linked_dirs, %w{log tmp/pids tmp/sockets}
set :puma_init_active_record, true

# capistrano/nginx
set :nginx_domains, 'pandify.com'
set :nginx_service_path, 'service nginx'
set :nginx_roles, :web

# Path where nginx log file will be stored
set :nginx_log_path, "#{shared_path}/log"

# Path where nginx is installed
set :nginx_root_path, '/etc/nginx'

# Path where to look for static files
set :nginx_static_dir, 'public'

# Path where nginx available site are stored
set :nginx_sites_available, 'sites-available'

# Path where nginx available site are stored
set :nginx_sites_enabled, 'sites-enabled'

# Whether you want to server an application through a proxy pass
set :app_server, true

# Socket file that nginx will use as upstream to serve the application
set :app_server_socket, "#{shared_path}/tmp/sockets/puma.sock"

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
# set :deploy_to, '/var/www/my_app'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

before :deploy, 'puma:config'

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
