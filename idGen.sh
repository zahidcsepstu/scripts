#!/bin/bash

echo -e "Module Name(spinal-case)?"
read module
echo -e "tab/menu/sub-menu name(spinal-case)?"
read taskName
echo -e "Prefix for root objects TECHDISER_ID(camelCase)?"
read prefix
echo -e "Template TECHDISER_ID Without Prefix(camelCase)?"
read templateRootIdWOprefix
echo -e "Attribute Name(camelCase)? Id will be generated for this attribute"
read attributeName
path=$(pwd)
appDirPath=${path%/main*}
moduleUnderscore=${module//-/_}
moduleUpperUnderScore=${moduleUnderscore^^}
taskUnderScore=${taskName//-/_}

finished=false
while ! $finished; do
    echo -e "Do you already have your json file?(Y/N)"
    read isJsonAvailable
    isJsonAvailable=${isJsonAvailable^^}
    if [[ $isJsonAvailable == 'Y' || $isJsonAvailable == 'N' ]]; then
        finished=true
    fi
done
templateRootId=$prefix$templateRootIdWOprefix
json="{
    "\""data"\"": [
        {
            "\""TECHDISER_ID"\"": "\""$templateRootId"\"",
            "\""$attributeName"\"": []
        }
    ]
}"

if [ $isJsonAvailable == 'Y' ]; then
    echo -e "Please make sure your json file follow this structure\n\n"
    echo "$json"
    echo -e "\n\n"
    echo "index.constants.json serviceName?"
    read exServiceName
    echo "index.constants.json taskName?"
    read exTaskName
else
    mkdir $appDirPath/data/$module
    touch $appDirPath/data/$module/$taskName.json
    echo "$json" >$appDirPath/data/$module/$taskName.json
    if grep -q ""\""$moduleUpperUnderScore"\"": {" $appDirPath/index.constants.js; then
        if grep -q ""\""$taskUnderScore"\"": "\""$module/$taskName.json"\""" $appDirPath/index.constants.js; then

            echo "Task "\""$taskUnderScore"\"" is already exist"
        else
            sed -i '0,/"'$moduleUpperUnderScore'": {/s//"'$moduleUpperUnderScore'": {\n                "'$taskUnderScore'": "'$module'\/'$taskName'.json", /' index.constants.js
        fi
        echo "Constant "\""$moduleUpperUnderScore"\"" is already exist"
    else
        sed -i '0,/.constant("CONSTANT_SERVICE_INFO", {/s//.constant("CONSTANT_SERVICE_INFO", {\n            "'$moduleUpperUnderScore'": {\n                "'$taskUnderScore'": "'$module'\/'$taskName'.json"\n            }, /' $appDirPath/index.constants.js
    fi
fi

taskNameUpperCase=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"$taskName")
taskNameCamelCase="$(tr '[:upper:]' '[:lower:]' <<<${taskNameUpperCase:0:1})${taskNameUpperCase:1}"
ctrlNameUpperCase=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"$module-$taskName")
ctrlNameCamelCase="$(tr '[:upper:]' '[:lower:]' <<<${ctrlNameUpperCase:0:1})${ctrlNameUpperCase:1}"
ctrlName=$ctrlNameCamelCase"Ctrl"

jsonJsFactName=$moduleUnderscore"_"$taskUnderScore"_json"

if [ $isJsonAvailable == 'Y' ]; then
    constantTaskName=$exTaskName
    constantserviceName=$exServiceName
else
    constantTaskName=$taskUnderScore
    constantserviceName=$moduleUpperUnderScore
fi

ctrl="(function () {
    'use strict';
    angular
        .module('app.$module')
        .controller('$ctrlName', $ctrlName);

    /** @ngInject */
    function $ctrlName(specDefHandlerService, \$stateParams, \$rootScope) {
        debugger
        var TECHDISER_COMPONENT_NAME = "\""$ctrlName"\"";
        var TECHDISER_SERVICE_INFO = {};
        var vm = this;
        vm.loadViewContent = true
        vm.preAsynchCallHandler = preAsynchCallHandler();
        vm.asynchCallHandler = asynchCallHandler();
        vm.postAsynchCallHandler = postAsynchCallHandler();
        vm.saveHandlerService = saveHandler();

        init();

        function init() {
            vm.preAsynchCallHandler.initHandler();
        }

        function preAsynchCallHandler() {

            var opPreAsync = {
                initHandler: initHandler,
                doOperation: doOperation,
                doNextOperation: doNextOperation
            }

            function initHandler() {
                vm.loadViewContent = false;
                doOperation();
            }

            function doOperation() {
                vm.$taskNameCamelCase"Config" = {
                    templatePath: "\""/[TECHDISER_ID=\$templateRootID]/$attributeName"\"",
                    templateRootID: "\""$templateRootId"\"", //hardcoded

                    pathPrefix: "\""/[TECHDISER_ID=\$dataSaveRootPath]"\"",
                    $attributeName: "\""/$attributeName"\"",
                    // contextObjectId: \$stateParams.contextId, //suffix, should be dynamic
                    contextObjectId: "\""$templateRootIdWOprefix"\"",

                    serviceName: "\""$constantserviceName"\"",
                    taskName: "\""$constantTaskName"\"",
                    jsonServiceName: "\""$jsonJsFactName"\""
                };

                vm.viewParams = [];

                doNextOperation();
            }

            function doNextOperation() {
                vm.asynchCallHandler.initHandler();
            }

            return opPreAsync;
        }

        function asynchCallHandler() {

            var opAsync = {
                initHandler: initHandler,
                doOperation: doOperation,
                doNextOperation: doNextOperation
            }

            function initHandler() {
                doOperation();
            }

            function doOperation() {
                idGenearationHandler();
            }

            function idGenearationHandler() {
                vm.viewParams.push({ "\""key"\"": "\""templateRootID"\"", "\""value"\"": vm.$taskNameCamelCase"Config".templateRootID });

                var params = angular.copy(vm.viewParams);

                params = specDefHandlerService.prepareParamInfo(
                    vm.$taskNameCamelCase"Config".serviceName,
                    vm.$taskNameCamelCase"Config".taskName,
                    vm.$taskNameCamelCase"Config".templatePath,
                    vm.$taskNameCamelCase"Config".pathPrefix + vm.$taskNameCamelCase"Config".$attributeName, //dataSavePath
                    vm.$taskNameCamelCase"Config".contextObjectId,
                    vm.$taskNameCamelCase"Config".jsonServiceName,
                    params
                );

                specDefHandlerService.generatePathIDs(function (updatedParams) {
                    if (updatedParams) {
                        vm.viewParams = updatedParams;
                        doNextOperation()
                    }

                }, params);
            }

            function doNextOperation() {
                vm.postAsynchCallHandler.initHandler();
            }

            return opAsync;
        }

        function postAsynchCallHandler() {
            var opPostAsync = {
                initHandler: initHandler,
                doOperation: doOperation,
                doNextOperation: doNextOperation
            }

            function initHandler() {
                doOperation();
            }

            function doOperation() {
                doNextOperation();
            }

            function doNextOperation() {
                vm.loadViewContent = true;
            }

            return opPostAsync;
        }

        function saveHandler() {

            var saveHandlerObj = {
                save: save
            };

            function save() {
                if (\$rootScope.unSaveState) {
                    var saveData = serviceName.prepareSaveData(vm.operationalData) //replace with your operational data
                    savePreparedData(function (data) {
                        if (data) {
                            \$rootScope.unSaveState = false
                            msbUtilService.showToast("\""Consumption Data Saved"\"", "\""success-toast"\"", 3000);
                        }
                        else
                            msbUtilService.showToast("\""Save Operation Failed"\"", "\""error-toast"\"", 3000);
                    }, vm.viewParams, saveData)

                }
            }

            function savePreparedData(callBack, params, saveData) {
                if (msbUtilService.checkUndefined(callBack, params)) {
                    var itemID = msbUtilService.searchFromParam(params, "\""dataSaveRootPath"\"");
                    var backeSavePath = msbUtilService.searchFromParam(params, SAVE_POLICY_SPEC.backeSavePath);
                    var backendConatinerObj = msbUtilService.searchFromParam(params, SAVE_POLICY_SPEC.preparedObj);

                    if (saveData && itemID) {
                        msbCommonApiService.saveInnerItem(itemID, saveData, vm.$taskNameCamelCase"Config".serviceName, vm.$taskNameCamelCase"Config".taskName, vm.$taskNameCamelCase"Config".$attributeName, params,
                            function (data) {
                                callBack(data)
                            }, null, null, true, true, backeSavePath, backendConatinerObj
                        );
                    }
                    else
                        callBack(null)
                }
            }

            return saveHandlerObj;
        }
    }
})();"

jsFileName=${taskName//-/.}
touch $jsFileName.ctrl.js
echo "$ctrl" >$jsFileName.ctrl.js

mkdir $appDirPath/common/specdef/$module

touch $appDirPath/common/specdef/$module/$jsFileName.json.js

attributeFunName="root-$attributeName""-def"
attributeFunNameUpperCase=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"$attributeFunName")
attributeFunNameCamelCase="$(tr '[:upper:]' '[:lower:]' <<<${attributeFunNameUpperCase:0:1})${attributeFunNameUpperCase:1}"

jsonJs="(function () {
    'use strict';

    angular
        .module('app.$module')
        .factory('$jsonJsFactName', $jsonJsFactName);

    /** @ngInject */
    function $jsonJsFactName(SAVE_POLICY_SPEC) {

        var service = {
            specInterface: specInterface,
            rootDef: rootDef,
            $attributeFunNameCamelCase: $attributeFunNameCamelCase
        };

        function rootDef(specType, servicePath) {

            var prefix = "\""$prefix"\"";

            function getIdSpec(servicePath) {

                var def = {
                    templatePath: "\""/"\"",
                    concateAttributes: ["\""prefix"\"", "\""contextObjectId"\""],
                    refereceObject: { prefix: prefix }
                };

                def[SAVE_POLICY_SPEC.pathId] = "\"""\"";

                return def;

            }

            function getPrefix() {
                return prefix;
            }

            function specInterface(specType, servicePath) {
                if (specType == SAVE_POLICY_SPEC.specType[0]) {
                    return getIdSpec(servicePath);
                } else if (specType == SAVE_POLICY_SPEC.specType[1]) {
                    return getPrefix();
                }
            }

            return specInterface(specType, servicePath);
        }

        function $attributeFunNameCamelCase(specType, servicePath) {

            var prefix = "\""$attributeName"\"";

            function getIdSpec(servicePath) {

                var def = {
                    templatePath: "\""/$attributeName"\"",
                    concateAttributes: ["\""prefix"\""],
                    refereceObject: { prefix: prefix }
                };

                def[SAVE_POLICY_SPEC.pathId] = "\"""\"";

                return def;
            }

            function getPrefix() {
                return prefix;
            }

            function specInterface(specType, servicePath) {
                if (specType == SAVE_POLICY_SPEC.specType[0]) {
                    return getIdSpec(servicePath);
                } else if (specType == SAVE_POLICY_SPEC.specType[1]) {
                    return getPrefix();
                }
            }

            return specInterface(specType, servicePath);

        }

        function specInterface(specType, servicePath, functionNames) {

            function getIdGenerationSpec(specType, servicePath, functionNames) {

                var idGenerationPolicies = [];
                if (functionNames) {
                    functionNames.forEach(function (functionName) {
                        if (functionName && service[functionName]) {
                            var executeableFunction = service[functionName];
                            var ideGenPolicy = executeableFunction(specType, servicePath);
                            if (ideGenPolicy) {
                                idGenerationPolicies.push(ideGenPolicy);
                            }
                        }
                    });
                }
                return idGenerationPolicies;
            }

            function fetchIdPrefix(specType, servicePath, functionNames) {

                var idPrefix = "\"""\"";
                if (functionNames && functionNames.length > 0) {
                    var executeableFunction = service[functionNames[functionNames.length - 1]];
                    idPrefix = executeableFunction(specType, servicePath);
                }
                return idPrefix;
            }

            function intOp(specType, servicePath, functionNames) {

                var info = null;

                if (specType == SAVE_POLICY_SPEC.specType[0]) {
                    info = getIdGenerationSpec(specType, servicePath, functionNames);
                } else if (specType == SAVE_POLICY_SPEC.specType[1]) {
                    info = fetchIdPrefix(specType, servicePath, functionNames);
                }

                return info;

            }

            return intOp(specType, servicePath, functionNames);

        }

        return service;

    }
})();"

echo "$jsonJs" >$appDirPath/common/specdef/$module/$jsFileName.json.js
