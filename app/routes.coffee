### @ngInject ###

global.cobudgetApp.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'
  $stateProvider
    .state 'landing', require('app/components/landing-page/landing-page.coffee')
    .state 'group', require('app/components/group-page/group-page.coffee')
    .state 'login', require('app/components/login-page/login-page.coffee')
    .state 'create-bucket', require('app/components/create-bucket-page/create-bucket-page.coffee')
    .state 'bucket', require('app/components/bucket-page/bucket-page.coffee')
    .state 'edit-bucket', require('app/components/edit-bucket-page/edit-bucket-page.coffee')
    .state 'admin', require('app/components/admin-page/admin-page.coffee')
    .state 'confirm-account', require('app/components/confirm-account-page/confirm-account-page.coffee')
    .state 'group-setup', require('app/components/group-setup-page/group-setup-page.coffee')
    .state 'forgot-password', require('app/components/forgot-password-page/forgot-password-page.coffee')
    .state 'reset-password', require('app/components/reset-password-page/reset-password-page.coffee')
    .state 'email-settings', require('app/components/email-settings-page/email-settings-page.coffee')
    .state 'profile-settings', require('app/components/profile-settings-page/profile-settings-page.coffee')
