angular
  .module('cobudget', ['config', 'ngRoute', 'restangular'])
  .config(window.Cobudget.Router)
  .directive('bucketList', window.Cobudget.BucketList)
  .directive('bucketSummary', window.Cobudget.BucketSummary)
  .directive('budgetBanner', window.Cobudget.BudgetBanner)
  .directive('navBar', window.Cobudget.NavBar)
  
