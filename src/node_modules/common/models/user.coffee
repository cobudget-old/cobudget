`// @ngInject`
angular.module('cobudget').factory 'UserModel',  () ->
  class UserModel
    constructor: (data = {}) ->
      @id = data.id
      @name = data.name

    serialize: ->
      return {
        id: @id
        name: @name
      }