null

### @ngInject ###
global.cobudgetApp.factory 'Currencies', () ->
  ->
    [{ code: 'USD', symbol: '$' },
    { code: 'NZD', symbol: '$' },
    { code: 'CAD', symbol: '$' },
    { code: 'GBP', symbol: '£' },
    { code: 'EUR', symbol: '€' },
    { code: 'CHF', symbol: 'CHF' },
    { code: 'JPY', symbol: '¥' },
    { code: 'DKK', symbol: 'DKK'}]
