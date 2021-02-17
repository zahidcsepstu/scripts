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

match="var vm = this"
added="\n\
        vm.done = function () {\n\
            \$mdDialog.hide("\""data\/module"\"");\n\
        }\n\
"
file="test.js"

# addLineAfterLastMatch "$match" "$added" "$file"
# spinal="spinal-case"
# module="module-name"
# camelCase=$(spinalToTitle "$module")
# camelCase=$(spinalToJsFileName "$module")
# touch $(spinalToJsFileName "$module")
# if isExists "'\$camelCase'/new" "case-type"; then echo "is directory"; else echo "nopes"; fi
camelCase="module-name"
camelCase=$(confirmAndContinue "case" "$camelCase")
echo $camelCase
