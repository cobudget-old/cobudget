set :application, "cobudget-api"
set :repository,  "git@github.com:enspiral/#{application}.git"
set :use_sudo,    false

set :normalize_asset_timestamps, false
default_run_options[:shell] = '/bin/bash --login'
set :scm, :git

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

task :staging do
  set :user,      "www"
  set :domain,    "craftworks.enspiral.info"
  set :branch,    "staging"
  set :rails_env, "staging"
  set :deploy_to, "/home/#{user}/#{application.gsub('-','/')}/"
  set :bundle_without, [:development, :test]

  role :web, domain
  role :app, domain
  role :db,  domain, :primary => true
end

namespace :site do
  task :symlink do
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
  end
end

require "bundler/capistrano"
after "deploy:restart", "deploy:cleanup"
