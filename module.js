(function () {
    'use strict';

    angular
        .module('app.template', [])
        .config(config);

    /** @ngInject */
    function config($stateProvider, msNavigationServiceProvider) {
        $stateProvider
            .state('app.template', {
                abstract: true,
                url: '/template'
            })            
            .state('app.template.menu-1', {
                url: 'menu-1',
                views: {
                    'content@app': {
                        templateUrl: 'app/main/test.html',
                        controller: 'ctrl as vm'
                    }
                }
            })            
            .state('app.template.menu-2', {
                url: 'menu-2',
                views: {
                    'content@app': {
                        templateUrl: 'app/main/test.html',
                        controller: 'ctrl as vm'
                    }
                }
            })            
            .state('app.template.menu-3', {
                url: 'menu-3',
                views: {
                    'content@app': {
                        templateUrl: 'app/main/test.html',
                        controller: 'ctrl as vm'
                    }
                }
            })
        msNavigationServiceProvider.saveItem('template', {
            title: 'template',
            icon: 'icon-desktop-mac',
            weight: -80
        });        
        msNavigationServiceProvider.saveItem('template.menu-1', {
            title: 'menu-1',
            state: 'app.template.menu-1',
            icon: 'icon-cog-box',
            weight: 1
        });        
        msNavigationServiceProvider.saveItem('template.menu-2', {
            title: 'menu-2',
            state: 'app.template.menu-2',
            icon: 'icon-cog-box',
            weight: 1
        });        
        msNavigationServiceProvider.saveItem('template.menu-3', {
            title: 'menu-3',
            state: 'app.template.menu-3',
            icon: 'icon-cog-box',
            weight: 1
        });

    }

})();
