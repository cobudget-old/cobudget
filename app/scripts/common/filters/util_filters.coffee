angular.module('filters.utils', [])
.filter('getByProperty', ()->
  (propertyName, propertyValue, collection) ->
    i = 0
    len = collection.length
    while i < len
      return collection[i]  if collection[i][propertyName] is +propertyValue
      i++
    null
)
