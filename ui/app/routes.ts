// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
/* @ngInject */

// Since Angular 1.6 the default hash-prefix used for $location has changed from the empty string
// to the bank ('!'). Since we're sending out links with only the hash, this needs to be set
// to the empty string
cobudgetApp.config([
  "$locationProvider",
  ($locationProvider) => $locationProvider.hashPrefix(""),
]);

cobudgetApp.config(function ($stateProvider, $urlRouterProvider) {
  $urlRouterProvider.otherwise("/");
  return $stateProvider
    .state("landing", require("app/components/landing-page/landing-page.ts"))
    .state("group", require("app/components/group-page/group-page.ts"))
    .state("login", require("app/components/login-page/login-page.ts"))
    .state(
      "create-bucket",
      require("app/components/create-bucket-page/create-bucket-page.ts")
    )
    .state("bucket", require("app/components/bucket-page/bucket-page.ts"))
    .state(
      "edit-bucket",
      require("app/components/edit-bucket-page/edit-bucket-page.ts")
    )
    .state("user", require("app/components/user-page/user-page.ts"))
    .state("admin", require("app/components/admin-page/admin-page.ts"))
    .state(
      "confirm-account",
      require("app/components/confirm-account-page/confirm-account-page.ts")
    )
    .state(
      "group-setup",
      require("app/components/group-setup-page/group-setup-page.ts")
    )
    .state(
      "forgot-password",
      require("app/components/forgot-password-page/forgot-password-page.ts")
    )
    .state(
      "reset-password",
      require("app/components/reset-password-page/reset-password-page.ts")
    )
    .state(
      "email-settings",
      require("app/components/email-settings-page/email-settings-page.ts")
    )
    .state(
      "profile-settings",
      require("app/components/profile-settings-page/profile-settings-page.ts")
    )
    .state(
      "manage-group-funds",
      require("app/components/manage-group-funds-page/manage-group-funds-page.ts")
    )
    .state(
      "review-bulk-allocation",
      require("app/components/review-bulk-allocation-page/review-bulk-allocation-page.ts")
    )
    .state(
      "invite-members",
      require("app/components/invite-members-page/invite-members-page.ts")
    )
    .state(
      "review-bulk-invite-members",
      require("app/components/review-bulk-invite-members-page/review-bulk-invite-members-page.ts")
    )
    .state(
      "analytics",
      require("app/components/analytics-page/analytics-page.ts")
    )
    .state(
      "resources",
      require("app/components/resources-page/resources-page.ts")
    )
    .state("about", require("app/components/about-page/about-page.ts"))
    .state("services", require("app/components/services-page/services-page.ts"))
    .state(
      "group-analytics",
      require("app/components/group-analytics-page/group-analytics-page.ts")
    );
});
