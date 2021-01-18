#!/bin/bash
# echo Module Name?
# read moduleName
# echo Menu Names?
# read menuNames
moduleName="template"
menuNames="menu-1 menu-2 menu-3"

module="(function () {
    'use strict';

    angular
        .module('app.$moduleName', [])
        .config(config);

    /** @ngInject */
    function config(\$stateProvider, msNavigationServiceProvider) {
        \$stateProvider
            .state('app.$moduleName', {
                abstract: true,
                url: '/$moduleName'
            })"
moduleSaveItem="
        msNavigationServiceProvider.saveItem('$moduleName', {
            title: '$moduleName',
            icon: 'icon-desktop-mac',
            weight: -80
        });"

for menuName in $menuNames; do
    menuState="
            .state('app.$moduleName.$menuName', {
                url: '$menuName',
                views: {
                    'content@app': {
                        templateUrl: 'app/main/test.html',
                        controller: 'ctrl as vm'
                    }
                }
            })"
    module+=$menuState

done
module+=$moduleSaveItem
for menuName in $menuNames; do
    menuItem="
        msNavigationServiceProvider.saveItem('$moduleName.$menuName', {
            title: '$menuName',
            state: 'app.$moduleName.$menuName',
            icon: 'icon-cog-box',
            weight: 1
        });"
    module+=$menuItem

done

last="

    }

})();"

module+=$last

echo "$module" >module.js

# match="MENUSTATE"

# echo "$module" | sed "s/$match/&$menuState/g"
# text="loremipsumNEEDLEdolorsitamet"
# word="HAYSTALK"

# echo "$module" | sed "s/$match/$word/g"

# echo Menu Names?
# read menuNames

# for menuName in $menuNames; do
#     mkdir $menuName
#     touch $menuName/$menuName.html
#     jsFileName=${menuName//-/.}
#     touch $menuName/$jsFileName.ctrl.js
#     echo $module >>$menuName/$jsFileName.ctrl.js
# done
