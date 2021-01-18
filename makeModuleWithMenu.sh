#!/bin/bash
cd src/app/main/
echo Module Name?
read moduleName
echo Menu Names?
read menuNames



if grep -q "'app.$moduleName'" ../index.module.js
then
    echo ""\""$moduleName"\"" is already exist"
else
    sed -i '1h;1!H;$!d;x;s/.*'\''[^\n]*/&,\n            '\''app.'"$moduleName"''\''/' ../index.module.js
fi


mkdir $moduleName
cd $moduleName

for menuName in $menuNames; do
    mkdir $menuName
    touch $menuName/$menuName.html
    jsFileName=${menuName//-/.}
    touch $menuName/$jsFileName.ctrl.js

    name_upper=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"$menuName")
    ctrlName="$(tr '[:upper:]' '[:lower:]' <<<${name_upper:0:1})${name_upper:1}"
    ctrlName+="Ctrl"

    ctrl="(function () {
    'use strict';
    angular
        .module('app.$moduleName')
        .controller('$ctrlName', $ctrlName);

    /** @ngInject */
    function $ctrlName() {
        debugger
        var TECHDISER_COMPONENT_NAME = "\""$ctrlName"\"";
        var TECHDISER_SERVICE_INFO = {};
        var vm = this;
        vm.loadViewContent = true
    }
})();"

    echo "$ctrl" >$menuName/$jsFileName.ctrl.js
    title_upper=$(sed 's/[^-]\+/\L\u&/g' <<<"$menuName")
    title=${title_upper//-/ }
    echo "<h1><center>This Is $title Index Page<center></h1>" > $menuName/$menuName.html
done

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

for menuName in $menuNames; do

    name_upper=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"$menuName")
    foo="$(tr '[:upper:]' '[:lower:]' <<<${name_upper:0:1})${name_upper:1}"
    foo+="Ctrl"
    menuState="
            .state('app.$moduleName.$menuName', {
                url: '/$menuName',
                views: {
                    'content@app': {
                        templateUrl: 'app/main/$moduleName/$menuName/$menuName.html',
                        controller: '$foo as vm'
                    }
                }
            })"
    module+=$menuState

done

moduleName_upper=$(sed 's/[^-]\+/\L\u&/g' <<<"$moduleName")
moduleTitle=${moduleName_upper//-/ }
moduleSaveItem="
        msNavigationServiceProvider.saveItem('$moduleName', {
            title: '$moduleTitle',
            icon: 'icon-desktop-mac',
            weight: -80
        });"

module+=$moduleSaveItem
for menuName in $menuNames; do
    title_upper=$(sed 's/[^-]\+/\L\u&/g' <<<"$menuName")
    title=${title_upper//-/ }
    menuItem="
        msNavigationServiceProvider.saveItem('$moduleName.$menuName', {
            title: '$title',
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
moduleFileName=${moduleName//-/.}
echo "$module" >$moduleFileName.module.js
