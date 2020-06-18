/* eslint-disable
    babel/new-cap,
    eqeqeq,
    no-shadow,
    no-undef,
    no-unused-vars,
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
cobudgetApp.factory('Session', function($auth, CurrentUser, Dialog, LoadBar, $location, $q, Records, $state) {
  let Session;
  return new (Session = class Session {
    create(formData, options) {
      if (options == null) { options = {}; }
      const promise = $auth.submitLogin(formData);
      promise.then(user => {
        cobudgetApp.currentUserId = user.id;
        __guard__(typeof HS !== 'undefined' && HS !== null ? HS.beacon : undefined, x => x.ready(() => HS.beacon.identify({
          name: user.name,
          email: user.email,
          url: location.href,
        })));
        const membershipsLoadedDeferred = $q.defer();
        cobudgetApp.membershipsLoaded = membershipsLoadedDeferred.promise;
        Records.users.updateProfile({utc_offset: moment().utcOffset()});
        return Records.memberships.fetchMyMemberships().then(data => {
          membershipsLoadedDeferred.resolve(data);
          return Records.users.fetchMe().then(() => {
            LoadBar.stop();
            switch (options.redirectTo) {
              case 'group':
                // here is where we would likely intercept if user wasn't confirmed
                if (CurrentUser().hasMemberships()) {
                  if (CurrentUser().isConfirmed()) {
                    return $location.path(`/groups/${CurrentUser().primaryGroup().id}`);
                  } else {
                    LoadBar.start();
                    return Records.users.requestReconfirmation().then(() => {
                      this.clear();
                      $state.go('login', {email: CurrentUser().email});
                      LoadBar.stop();
                      const content = `You have not yet confirmed your email address. We've sent another email to ${CurrentUser().email}. Please check your inbox to continue.`;
                      return Dialog.alert({title: 'error!', content});
                    });
                  }
                } else {
                  return this.clear().then(function() {
                    $location.path('/');
                    return Dialog.alert({title: 'error!', content: 'you have no active memberships'});
                  });
                }
              case 'group setup':
                return $location.path('/setup_group');
            }
          });
        });
      });
      promise.catch(() => LoadBar.stop());
      return promise;
    }

    clear() {
      const deferred = $q.defer();
      if (CurrentUser()) {
        $auth.signOut().then(function() {
          cobudgetApp.currentUserId = null;
          __guard__(typeof HS !== 'undefined' && HS !== null ? HS.beacon : undefined, x => x.ready(() => HS.beacon.identify({
            name: null,
            email: null,
            url: null,
          })));
          return deferred.resolve();
        });
      } else {
        deferred.resolve();
      }
      return deferred.promise;
    }
  });
});

function __guard__(value, transform) {
  return (typeof value !== 'undefined' && value !== null) ? transform(value) : undefined;
}