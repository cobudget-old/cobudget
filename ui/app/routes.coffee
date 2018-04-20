### @ngInject ###

# Since Angular 1.6 the default hash-prefix used for $location has changed from the empty string
# to the bank ('!'). Since we're sending out links with only the hash, this needs to be set
# to the empty string
global.cobudgetApp.config(['$locationProvider', ($locationProvider) ->
  $locationProvider.hashPrefix('')])

global.cobudgetApp.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise '/'
  $stateProvider
    .state 'landing', require('app/components/landing-page/landing-page.coffee')
    .state 'group', require('app/components/group-page/group-page.coffee')
    .state 'login', require('app/components/login-page/login-page.coffee')
    .state 'create-bucket', require('app/components/create-bucket-page/create-bucket-page.coffee')
    .state 'bucket', require('app/components/bucket-page/bucket-page.coffee')
    .state 'edit-bucket', require('app/components/edit-bucket-page/edit-bucket-page.coffee')
    .state 'user', require('app/components/user-page/user-page.coffee')
    .state 'admin', require('app/components/admin-page/admin-page.coffee')
    .state 'confirm-account', require('app/components/confirm-account-page/confirm-account-page.coffee')
    .state 'group-setup', require('app/components/group-setup-page/group-setup-page.coffee')
    .state 'forgot-password', require('app/components/forgot-password-page/forgot-password-page.coffee')
    .state 'reset-password', require('app/components/reset-password-page/reset-password-page.coffee')
    .state 'email-settings', require('app/components/email-settings-page/email-settings-page.coffee')
    .state 'profile-settings', require('app/components/profile-settings-page/profile-settings-page.coffee')
    .state 'manage-group-funds', require('app/components/manage-group-funds-page/manage-group-funds-page.coffee')
    .state 'review-bulk-allocation', require('app/components/review-bulk-allocation-page/review-bulk-allocation-page.coffee')
    .state 'invite-members', require('app/components/invite-members-page/invite-members-page.coffee')
    .state 'review-bulk-invite-members', require('app/components/review-bulk-invite-members-page/review-bulk-invite-members-page.coffee')
    .state 'analytics', require('app/components/analytics-page/analytics-page.coffee')
    .state 'resources', require('app/components/resources-page/resources-page.coffee')
    .state 'about', require('app/components/about-page/about-page.coffee')
    .state 'group-analytics', require('app/components/group-analytics-page/group-analytics-page.coffee')
