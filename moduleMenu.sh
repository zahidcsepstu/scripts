#!/bin/bash
readonly TD_PATH="/home/zahid/client-rndnnnn/client-rnd"

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
    jsFileName+=".module.js"
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
    echo -e "\n$1 : $2 (Press Enter to Confirm Otherwise Provide Correct Name)" >&2
    echo -n "$1 : " >&2
    read name
    if [ -z "$name" ]; then
        echo -e "$1 : $2 CONFIRMED\n\n" >&2
        echo "$2"
    else
        echo -e "$1 : $name (CONFIRMED)\n\n" >&2
        echo "$name"
    fi
}

getMODULE() {
    # moduleName moduleTitle
    echo "\
(function () {
    'use strict';

    angular
        .module('app.$1', [])
        .config(config);

    /** @ngInject */
    function config(\$stateProvider, msNavigationServiceProvider) {
        \$stateProvider
            .state('app.$1', {
                abstract: true,
                url: '/$1'
            })
        //CODE_GENERATOR_MARKER_STATE
        msNavigationServiceProvider.saveItem('$1', {
            title: '$2',
            icon: 'icon-desktop-mac',
            weight: -100
        });
        //CODE_GENERATOR_MARKER_SAVE_ITEM
    }

})();\
"
}

getSTATE() {
    # state menuName controller moduleDir
    echo "\
            .state('$1', {\n\
                url: '\/$2',\n\
                views: {\n\
                    'content@app': {\n\
                        templateUrl: 'app\/main\/$4\/$2\/$2.html',\n\
                        controller: '$3 as vm'\n\
                    }\n\
                }\n\
            })\
"

}

getSAVE_ITEM() {
    # moduleName menuName menuTitle
    echo "\
        msNavigationServiceProvider.saveItem('$1.$2', {\n\
            title: '$3',\n\
            state: 'app.$1.$2',\n\
            icon: 'icon-cog-box',\n\
            weight: 1\n\
        });\
"
}

# echo "$MODULE" >module.js
# addLineBeforeFirstMatch "\/\/CODE_GENERATOR_MARKER_STATE" "$STATE" "module.js"
# addLineBeforeFirstMatch "\/\/CODE_GENERATOR_MARKER_SAVE_ITEM" "$SAVE_ITEM" "module.js"

# if isExists "$SAVE_ITEM" "module.js"; then echo "is directory"; else echo "nopes"; fi
# echo $TD_PATH

# echo -e "Use spinal-case naming convention"
# echo "Module Name(spinal-case)"?
# read moduleName

# echo -e "\nMenu Names(Use spinal-case naming convention. For multiple menu separate using space)?"
# read menuNames
# menuNames="menu-one menu-two menu-three"

# echo -e "\n\nTo use layout for menu use option\n 1: Simple Workspace\n 2: Info Menu Workspace\n 3: Side Nav workspace\nPress enter for none\n"

# COUNTER=0
# for menuName in $menuNames; do
#     echo -e "\n"
#     echo -n "$menuName layout : "
#     read layout
#     if [[ $layout == 2 ]]; then
#         echo -n "$menuName info menu level(1-3) : "
#         read level
#     else
#         level=0
#     fi
#     declare -A menuList$COUNTER="(
#         [menuName]="$menuName"
#         [layout]=$layout
#         [level]=$level
#     )"
#     COUNTER+=1
# done
logString="\n\n"
moduleName="bash-test"

declare -A menuList0=(
    [menuName]='menu-one'
    [layout]=1
    [level]=0
)
declare -A menuList1=(
    [menuName]='menu-two'
    [layout]=2
    [level]=1
)

declare -n menuList

moduleDirName=$(confirmAndContinue "Module Directory Name" "$moduleName")
moduleTitle=$(spinalToTitle "$moduleName")

if isDirectory $TD_PATH/src/app/main/$moduleDirName; then
    logString+="Directory Already Exists\n"
else
    mkdir $TD_PATH/src/app/main/$moduleDirName
    logString+="Created Directory $moduleDirName $(pwd)\n"
fi

moduleFileName=$(spinalToModuleFileName "$moduleName")
moduleFileName=$(confirmAndContinue "Module File Name" "$moduleFileName")

moduleAppName=$(confirmAndContinue "Module APP Name" "$moduleName")

if isFile $TD_PATH/src/app/main/$moduleDirName/$moduleFileName; then
    logString+="File Already Exists\n"
else
    touch $TD_PATH/src/app/main/$moduleDirName/$moduleFileName
    logString+="Created File $moduleFileName"
    MODULE=$(getMODULE "$moduleAppName" "$moduleTitle")
    echo "$MODULE" >$TD_PATH/src/app/main/$moduleDirName/$moduleFileName
fi

for menuList in ${!menuList@}; do
    # echo "Menu Name: ${menuList[menuName]}"
    # echo "Layout: ${menuList[layout]}"
    # echo "level: ${menuList[level]}"
    menuSate="app.$moduleAppName.${menuList[menuName]}"
    menuSate=$(confirmAndContinue "${menuList[menuName]} State" "$menuSate")
    menuControllerName=$(spinalToCtrlName "${menuList[menuName]}")
    menuSTATE=$(getSTATE "$menuSate" "${menuList[menuName]}" "$menuControllerName" "$moduleDirName")
    addLineBeforeFirstMatch "\/\/CODE_GENERATOR_MARKER_STATE" "$menuSTATE" "$TD_PATH/src/app/main/$moduleDirName/$moduleFileName"
done

echo -e $logString
