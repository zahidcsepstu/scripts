#!/bin/bash
addLineBeforeFirstMatch() {
    sed -i "0,/.*$1.*/s/.*$1.*/$2\n&/" $3
}

addLineAfterFirstMatch() {
    sed -i "0,/$1/!b;//a\\$2" $3
}

addLineAfterLastMatch() {
    sed -i "1h;1!H;\$!d;x;s/.*$1[^\n]*/&$2/" $3
}

spinalToCamel() {
    local pascalCase=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"$1")
    local camelCase="$(tr '[:upper:]' '[:lower:]' <<<${pascalCase:0:1})${pascalCase:1}"
    echo "$camelCase"
}

spinalToCtrlName() {
    local pascalCase=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"$1-$2")
    local camelCase="$(tr '[:upper:]' '[:lower:]' <<<${pascalCase:0:1})${pascalCase:1}"
    camelCase+="Ctrl"
    echo "$camelCase"
}

spinalToTitle() {
    local upperCase=$(sed 's/[^-]\+/\L\u&/g' <<<"$1")
    local title=${upperCase//-/ }
    echo "$title"
}

spinalToJsFileName() {
    local jsFileName=${1//-/.}
    jsFileName+=".ctrl.js"
    echo "$jsFileName"
}

spinalToModuleFileName() {
    local jsFileName=${1//-/.}
    jsFileName+=".ctrl.js"
    echo "$jsFileName"
}

isDirectory() {
    [ -d "$1" ]
}

isFile() {
    [ -f "$1" ]
}

isExists() {
    echo "$1"
    grep -q "$1" $2
}

confirmAndContinue() {
    echo "$1:$2? (Press enter to confirm)" >&2
    read name
    if [ -z "$name" ]; then
        echo "$2"
    else
        echo "$name"
    fi
}

MODULE="\
(function () {
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
            })
        //CODE_GENERATOR_MARKER_STATE
        msNavigationServiceProvider.saveItem('$moduleName', {
            title: '$moduleTitle',
            icon: 'icon-desktop-mac',
            weight: -100
        });
        //CODE_GENERATOR_MARKER_SAVE_ITEM
    }

})();\
"

STATE="\
            .state('app.$moduleName.$menuName', {\n\
                url: '\/$menuName',\n\
                views: {\n\
                    'content@app': {\n\
                        templateUrl: 'app\/main\/$moduleName\/$menuName\/$menuName.html',\n\
                        controller: '$nameFirstLower as vm'\n\
                    }\n\
                }\n\
            })\
"

SAVE_ITEM="\
        msNavigationServiceProvider.saveItem('$moduleName.$menuName', {\n\
            title: '$title',\n\
            state: 'app.$moduleName.$menuName',\n\
            icon: 'icon-cog-box',\n\
            weight: 1\n\
        });\
"

# echo "$MODULE" >module.js
# addLineBeforeFirstMatch "\/\/CODE_GENERATOR_MARKER_STATE" "$STATE" "module.js"
# addLineBeforeFirstMatch "\/\/CODE_GENERATOR_MARKER_SAVE_ITEM" "$SAVE_ITEM" "module.js"

# if isExists "$SAVE_ITEM" "module.js"; then echo "is directory"; else echo "nopes"; fi
