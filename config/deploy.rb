require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

require_relative 'deploy/foreman'

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, 'stockers.nl'
set :deploy_to, '/home/crypto'
set :repository, 'git@github.com:boymaas/crypto.git'
set :branch, 'master'

unless ENV['production_deploy']
  set :domain, '192.168.33.10'
  # set :port, '2222'     # SSH port number.
  set :identity_file, "#{ENV['HOME']}/.vagrant.d/insecure_private_key"
end

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log']

# Optional settings:
set :user, 'crypto'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
#
# Vagrant settings

set :foreman_app, :crypto
set :foreman_user, :crypto
set :foreman_concurrency, { 
  :web => 1,
  :data_collector => 1,
  :bot_runner => 1,
  :vacuum => 1 
}

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'link_extra_shared_paths'
    invoke :'bundle:install'
    invoke :'check_rbenv'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      invoke 'foreman:export'
      invoke 'foreman:restart'
    end
  end
end

task :link_extra_shared_paths => :environment do
    queue  %{
      echo "-----> linking extra shared paths"
      #{echo_cmd(%{ln -s "#{deploy_to}/#{shared_path}/config/env" "./.env"})}
    }
end

task :check_rbenv => :environment do
    queue  %{
      echo "-----> checking rbenv"
      #{echo_cmd %{echo $PWD}}
      #{echo_cmd %{rbenv local}}
    }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

