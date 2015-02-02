### @ngInject ###
module.exports = (options) ->
  template: require('./error-modal-template.html')
  controller: require('./error-modal-controller.coffee')
  size: 'lg'
  resolve:
    error: ->
      options.error
