/*global toString */
(function( angular ) {
  'use strict';

  var isBoolean = function ( obj ) {
    return obj === true || obj === false || Object.prototype.toString.call(obj) === '[object Boolean]';
  };

  cobudgetApp.
    filter('currency', ['$injector', '$locale', function ( $injector, $locale ) {
      var $filter = $injector.get('$filter');
      var numberFilter = $filter('number');
      var formats = $locale.NUMBER_FORMATS;
      var pattern = formats.PATTERNS[1];
      // https://github.com/angular/angular.js/pull/3642
      formats.DEFAULT_PRECISION = angular.isUndefined(formats.DEFAULT_PRECISION) ? 2 : formats.DEFAULT_PRECISION;
      return function ( amount, currencySymbol, fractionSize, suffixSymbol, customFormat ) {
        suffixSymbol = true
        if ( currencySymbol == '$' || currencySymbol == '£' || currencySymbol == '€' || currencySymbol == '¥' ) { suffixSymbol = false }
        if ( !angular.isNumber(amount) ) { amount = 0; }
        if ( angular.isObject(currencySymbol) ) { customFormat = currencySymbol; }
        if ( angular.isUndefined(currencySymbol) || angular.isObject(currencySymbol) ) { currencySymbol = formats.CURRENCY_SYM; }
        var isNegative = amount < 0;
        var parts = [];

        if (isBoolean(fractionSize) || angular.isString(fractionSize)) {
            suffixSymbol = fractionSize;
            fractionSize = formats.DEFAULT_PRECISION;
        }

        fractionSize = angular.isUndefined(fractionSize) ? formats.DEFAULT_PRECISION : fractionSize;

        amount = Math.abs(amount);

        var groupSep = customFormat && angular.isString(customFormat.GROUP_SEP) ? customFormat.GROUP_SEP : formats.GROUP_SEP;
        var decimalSep = customFormat && angular.isString(customFormat.DECIMAL_SEP) ? customFormat.DECIMAL_SEP : formats.DECIMAL_SEP;
        var number = numberFilter( amount, fractionSize );

        var formattedNumber = [];
        for (var i = 0; i < number.length; i++) {
          if (number[i] === formats.GROUP_SEP)
            formattedNumber.push(groupSep);
          else if (number[i] === formats.DECIMAL_SEP)
            formattedNumber.push(decimalSep);
          else
            formattedNumber.push(number[i]);
        }
        formattedNumber = formattedNumber.join('');

        parts.push(isNegative ? pattern.negPre : pattern.posPre);

        if (angular.isString(suffixSymbol)) {
            parts.push(currencySymbol);
            parts.push(formattedNumber);
            parts.push(suffixSymbol);
        } else {
            parts.push(!suffixSymbol ? currencySymbol : formattedNumber);
            parts.push(suffixSymbol ? currencySymbol : formattedNumber);
        }

        parts.push(isNegative ? pattern.negSuf : pattern.posSuf);

        return parts.join('').replace(/\u00A4/g, '');
      };
    }]);

}( angular ));
