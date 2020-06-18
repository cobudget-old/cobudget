/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
// http://i.imgur.com/RMs4njZ.gifv

export default {
  onEnter($location) {
    return $location.url($location.path());
  },
  resolve: {
    userValidated($auth) {
      return $auth.validateUser();
    },
    membershipsLoaded() {
      return global.cobudgetApp.membershipsLoaded;
    }
  },
  url: '/setup_group',
  template: require('./group-setup-page.html'),
  controller(LoadBar, Records, $scope, $state, Currencies, $location) {

    $scope.createGroup = function(formData) {
      LoadBar.start();
      return Records.groups.build({name: formData.name, currencyCode: formData.currency.code, currencySymbol: formData.currency.symbol}).save().then(() => Records.memberships.fetchMyMemberships().then(function(data) {
        const newGroup = _.find(data.groups, group => group.name === formData.name);
        $state.go('group', {groupId: newGroup.id, firstTimeSeeingGroup: true});
        return LoadBar.stop();
      }));
    };

    $scope.currencies = Currencies();

    return $scope.cancel = () => $location.path('/');
  }
};
