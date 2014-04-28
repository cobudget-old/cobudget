##Cobudget front end

#### Configuration

We are using env-config and grunt-replace to manage configuration - checkout [this article](http://newtriks.com/2013/11/29/environment-specific-configuration-in-angularjs-using-grunt/) for an overview

To get up and running copy `config/environments/sample.json` to `config/environments/development.json` and add your custom settings.

Likewise you will need to setup production.json and staging.json for deploying to work.

*To run locally:*

Install node and npm: https://github.com/joyent/node/wiki/Installation 
Install yeoman: yeoman.io

sudo npm install
bower install

*Start the server:*

grunt server

*install Gems*
compass
capistrano -v2.15.5
railsless-deploy
