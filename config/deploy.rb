set :application, "cobudget"

set :repository, "deploy_package.tar.gz"
set :scm, :none 

set :use_sudo,    false

ssh_options[:forward_agent] = true
#default_run_options[:pty] = true
#default_run_options[:shell] = '/bin/bash --login'

set :default_stage, "staging"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

set :deploy_to, "/home/www/#{application}/client/"
task :staging do
  role :web, "www@cobudget.enspiral.info"
  role :app, "www@cobudget.enspiral.info"
  set :deploy_to, "/home/www/#{application}/client/"
end

namespace :deploy do
  task :build do
    system "grunt --force"
  end

  task :compress do
    system "tar -zcvf deploy_package.tar.gz dist"
  end

  task :upload do
    system("scp -r deploy_package.tar.gz www@cobudget.enspiral.info:#{deploy_to}/deploy_package.tar.gz")
  end

  task :update_code do
    run "mkdir #{release_path}"
    run "cp -R #{deploy_to}deploy_package.tar.gz #{release_path}/"
  end

  task :uncompress_and_clean_up do
    run "cd #{release_path} && tar -zxvf deploy_package.tar.gz --strip-components=1"
    #run "mv #{release_path}/dist/* #{release_path}/"
  end

  before "deploy:update_code", "deploy:build"
  after "deploy:build", "deploy:compress"
  after "deploy:compress", "deploy:upload"
  after "deploy:update_code", "deploy:uncompress_and_clean_up"
end
