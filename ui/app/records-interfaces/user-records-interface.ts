/*
 * decaffeinate suggestions:
 * DS001: Remove Babel/TypeScript constructor workaround
 * DS102: Remove unnecessary code created because of implicit returns
 * DS206: Consider reworking classes to avoid initClass
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
global.cobudgetApp.factory('UserRecordsInterface', function(config, BaseRecordsInterface, $q, UserModel) {
  let UserRecordsInterface;
  return UserRecordsInterface = (function() {
    UserRecordsInterface = class UserRecordsInterface extends BaseRecordsInterface {
      static initClass() {
        this.prototype.model = UserModel;
      }
      constructor(recordStore) {
        {
          // Hack: trick Babel/TypeScript into allowing this before super.
          if (false) { super(); }
          let thisFn = (() => { return this; }).toString();
          let thisName = thisFn.match(/return (?:_assertThisInitialized\()*(\w+)\)*;/)[1];
          eval(`${thisName} = this;`);
        }
        this.baseConstructor(recordStore);
        this.remote.apiPrefix = config.apiPrefix;
      }

      confirmAccount(params){
        return this.remote.post('confirm_account', params);
      }

      requestPasswordReset(params) {
        return this.remote.post('request_password_reset', params);
      }

      requestReconfirmation() {
        return this.remote.post('request_reconfirmation', {});
      }

      resetPassword(params) {
        return this.remote.post('reset_password', params);
      }

      updateProfile(params) {
        params = morph.toSnake(params);
        return this.remote.post('update_profile', {user: params});
      }

      inviteToCreateGroup(params) {
        return this.remote.post('invite_to_create_group', params);
      }

      updatePassword(params) {
        return this.remote.post('update_password', params);
      }

      fetchUserById(userId) {
        const deferred = $q.defer();
        this.remote.get(userId, {}).then(user => deferred.resolve(user));
        return deferred.promise;
      }

      fetchMe() {
        const deferred = $q.defer();
        if (this.find(global.cobudgetApp.currentUserId)) {
          // if it becomes necessary, re-fetch the current_user in the background
          deferred.resolve();
        } else {
          this.remote.get('me', {}).then(() => deferred.resolve());
        }
        return deferred.promise;
      }
    };
    UserRecordsInterface.initClass();
    return UserRecordsInterface;
  })();
});
