/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
/* @ngInject */

global.cobudgetApp.config(markedProvider => markedProvider.setRenderer({
  link(href, title, text) {
    if (href.startsWith('uid:')) {
      return '<a href=\'#/users/' + href.replace('uid:','') + '\'' + ' target=\'_blank\'>' + text + '</a>';
    } else {
      return '<a href=\'' + href + '\'' + (title ? ' title=\'' + title + '\'' : '') + ' target=\'_blank\'>' + text + '</a>';
    }
  }
}));
