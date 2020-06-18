/* eslint-disable
    no-undef,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS103: Rewrite code to no longer use __guard__
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.run(function($auth, CurrentUser, Dialog, LoadBar, $location, $q, Records, $rootScope, Toast, $window) {

  const membershipsLoadedDeferred = $q.defer();
  const announcementsLoadedDeferred = $q.defer();
  global.cobudgetApp.membershipsLoaded = membershipsLoadedDeferred.promise;
  global.cobudgetApp.announcementsLoaded = announcementsLoadedDeferred.promise;


  $rootScope.$on('auth:validation-success', function(ev, user) {
    global.cobudgetApp.currentUserId = user.id;
    if (user.is_super_admin) {
      let groupId;
      const pathComponents = $location.path().split('/');
      if (pathComponents[1] === 'groups') {
        groupId = pathComponents[2];
        Records.memberships.fetchMyMembershipsSuper(groupId).then(data => membershipsLoadedDeferred.resolve(data));
      } else if (pathComponents[1] === 'buckets') {
        const bucketId = parseInt(pathComponents[2]);
        Records.buckets.findOrFetchById(bucketId).then(function(bucket) {
          groupId = bucket.group().id;
          return Records.memberships.fetchMyMembershipsSuper(groupId).then(data => membershipsLoadedDeferred.resolve(data));
        });
      } else {
        Records.memberships.fetchMyMemberships().then(data => membershipsLoadedDeferred.resolve(data));
      }
    } else {
      Records.memberships.fetchMyMemberships().then(data => membershipsLoadedDeferred.resolve(data));
    }
    Records.announcements.fetch({}).then(data => announcementsLoadedDeferred.resolve(data));
    if (typeof Sentry !== 'undefined' && Sentry !== null) {
      Sentry.setUser({email});
    }
    return __guard__(typeof HS !== 'undefined' && HS !== null ? HS.beacon : undefined, x => x.ready(() => HS.beacon.identify({
      name: user.name,
      email: user.email,
      url: location.href,
    })));
  });

  $rootScope.$on('auth:login-error', function(ev, reason) {
    Dialog.alert({title: 'error!', content: reason.errors[0]});
    return __guard__(typeof HS !== 'undefined' && HS !== null ? HS.beacon : undefined, x => x.ready(() => HS.beacon.identify({
      name: null,
      email: null,
      url: null,
    })));
  });

  return $rootScope.$on('$stateChangeError', function(e, toState, toParams, fromState, fromParams, error) {
    if (typeof Sentry !== 'undefined' && Sentry !== null) {
      Sentry.captureException(error, { e, toState, toParams, fromState, fromParams });
    }

    console.log('$stateChangeError signal fired!');
    console.log('e: ', e);
    console.log('toState: ', toState);
    console.log('toParams: ', toParams);
    console.log('fromState: ', fromState);
    console.log('fromParams: ', fromParams);
    console.log('error: ', error);

    if (error) {
      e.preventDefault();
      global.cobudgetApp.currentUserId = null;
      membershipsLoadedDeferred.reject();
      announcementsLoadedDeferred.reject();
      Toast.show('Please log in to continue');
      return $location.path('/');
    } else {
      return $window.location.reload();
    }
  });
});

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}