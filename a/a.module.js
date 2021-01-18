(function () {
    'use strict';

    angular
        .module('app.a', [])
        .config(config);

    /** @ngInject */
    function config($stateProvider, msNavigationServiceProvider) {
        $stateProvider
            .state('app.a', {
                abstract: true,
                url: '/a'
            })
            .state('app.a.a', {
                url: '/a',
                views: {
                    'content@app': {
                        templateUrl: 'app/main/a/a/a.html',
                        controller: 'aCtrl as vm'
                    }
                }
            })
        msNavigationServiceProvider.saveItem('a', {
            title: 'A',
            icon: 'icon-desktop-mac',
            weight: -80
        });
        msNavigationServiceProvider.saveItem('a.a', {
            title: 'A',
            state: 'app.a.a',
            icon: 'icon-cog-box',
            weight: 1
        });

    }

})();
