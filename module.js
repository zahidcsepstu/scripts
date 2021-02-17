(function () {
    'use strict';

    angular
        .module('app.', [])
        .config(config);

    /** @ngInject */
    function config($stateProvider, msNavigationServiceProvider) {
        $stateProvider
            .state('app.', {
                abstract: true,
                url: '/'
            })
            .state('app..', {
                url: '/',
                views: {
                    'content@app': {
                        templateUrl: 'app/main///.html',
                        controller: ' as vm'
                    }
                }
            })


            .state('app.bash-test.menu-one', {
                url: '/menu-one',
                views: {
                    'content@app': {
                        templateUrl: 'app/main/bash-test/menu-one/menu-one.html',
                        controller: 'menuOne-Ctrl as vm'
                    }
                }
            })
            .state('app.bash-test.menu-two', {
                url: '/menu-two',
                views: {
                    'content@app': {
                        templateUrl: 'app/main/bash-test/menu-two/menu-two.html',
                        controller: 'menuTwo-Ctrl as vm'
                    }
                }
            })
        //CODE_GENERATOR_MARKER_STATE
        msNavigationServiceProvider.saveItem('', {
            title: '',
            icon: 'icon-desktop-mac',
            weight: -100
        });
        msNavigationServiceProvider.saveItem('.', {
            title: '',
            state: 'app..',
            icon: 'icon-cog-box',
            weight: 1
        });
        //CODE_GENERATOR_MARKER_SAVE_ITEM
    }

})();
