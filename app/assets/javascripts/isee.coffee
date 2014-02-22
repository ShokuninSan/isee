'use strict'

require(['controllers', 'models', 'services'], ->

  angular.element(document).ready ->
    angular.module('isee', ['isee.models', 'isee.services', 'isee.controllers'])
    angular.bootstrap document, ['isee']

)