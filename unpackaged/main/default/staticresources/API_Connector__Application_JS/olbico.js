angular.module('olbicoApp', ['service-factory'])
.config(['$sceDelegateProvider', '$compileProvider', function ($sceDelegateProvider, $compileProvider) {
    var a = $('<a>', { href: application_js })[0];
    var url = a.protocol + '//' + a.hostname + '/**';
    console.log('url::' + url);
    $sceDelegateProvider.resourceUrlWhitelist([
        // Allow same origin resource loads.
        'self',
        // Allow loading from outer templates domain.
        
        url
       
    ]);
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|data|chrome-extension):/);

}])
.controller('olbicoController', ["$scope",  function ($scope) {
   
}])
.directive('leadMapping', function () {

    return {
        templateUrl: application_js + "templates/olbico.html",
        controller: ["$scope","$compile","$toaster", function ($scope,$compile,$toaster) {

            $scope.username = '';
            $scope.password = '';
            $scope.IsAccount = false;
            $scope.IsContact = false;
            $scope.IsDisable = true;
            $scope.IsCheckCredit = false;
            $scope.mapDuns = '';

            $scope.leadFields = [];
            $scope.accountFields = [];
            $scope.leadMapFields = [];
            $scope.leadMapConFields = [];
            //$scope.MappingRow = [];
            $scope.leadMapFieldsFlag = false;
            $scope.leadFieldsFlag = false;
            $scope.leadMapConFieldsFlag = false;

            $scope.recordAccount = [];
            $scope.recordAccountTemp = [];
            $scope.recordContact = [];
            $scope.recordContactTemp = [];

            olbico.Engine.mappingFields(function (resultFieldMap, event) {
                if (resultFieldMap != null) {
                    if (resultFieldMap.Account != null) {
                        $scope.recordAccount = angular.copy(resultFieldMap.Account);
                        $scope.recordAccountTemp = angular.copy(resultFieldMap.Account);
                    } else if (resultFieldMap.Account == null) {
                        var obj = { 'name': '', value: '' };
                        $scope.recordAccount.push(obj);
                        $scope.recordAccountTemp.push(obj);
                    }
                    if (resultFieldMap.Contact != null) {
                        $scope.recordContact = angular.copy(resultFieldMap.Contact);
                        $scope.recordContactTemp = angular.copy(resultFieldMap.Contact);
                    } else if (resultFieldMap.Contact == null) {
                        var obj = { 'name': '', value: '' };
                        $scope.recordContact.push(obj);
                        $scope.recordContactTemp.push(obj);
                    }
                    
                } 
                
            }, { escape: true })

            olbico.Engine.userInformation(function (resultUserInfo, event) {
                if (resultUserInfo != null) {
                    $scope.username = resultUserInfo.Duplicate != null?resultUserInfo.Duplicate.olbico__Username__c :'';
                    $scope.password = resultUserInfo.Duplicate != null?resultUserInfo.Duplicate.olbico__Password__c:'';
                    $scope.IsAccount =resultUserInfo.Duplicate != null? resultUserInfo.Duplicate.olbico__IsAccountTrigger__c:false;
                    $scope.IsContact =resultUserInfo.Duplicate != null?resultUserInfo.Duplicate.olbico__IsContactTrigger__c:false;
                    
                    $scope.mapDuns = resultUserInfo.Credit != null?resultUserInfo.Credit.olbico__D_U_N_S_Number_Custom_Field__c:'';

                    $scope.IsCheckCredit = resultUserInfo.Trigger != null?resultUserInfo.Trigger.olbico__IsActive__c:false;
                } 

            }, { escape: true })

            olbico.Engine.leadFields(function (resultleadflds, event) {
                if (resultleadflds != null) {
                    angular.forEach(resultleadflds.Lead, function (value, key) {
                        var obj = { 'Name': value };
                        $scope.leadFields.push(obj);
                    });
                    angular.forEach(resultleadflds.Account, function (value, key) {
                        var obj = { 'Name': value };
                        $scope.accountFields.push(obj);
                    });
                    $scope.leadFieldsFlag = true;
                    $scope.$apply();
                }
            }, { escape: true });
       
            
            olbico.Engine.makeGetAccCallout(function (resultMapflds, event) {
                if (resultMapflds != null) {
                    angular.forEach(resultMapflds, function (value, key) {
                        var obj = { 'Name': value };
                        $scope.leadMapFields.push(obj);
                    });
                    $scope.leadMapFieldsFlag = true;
                    $scope.$apply();
                }
            }, { escape: true }
        );
            olbico.Engine.makeGetConCallout(function (resultMapConflds, event) {
                if (resultMapConflds != null) {
                    angular.forEach(resultMapConflds, function (value, key) {
                        var obj = { 'Name': value };
                        $scope.leadMapConFields.push(obj);
                    });
                    $scope.leadMapConFieldsFlag = true;
                    $scope.$apply();
                }
            }, { escape: true }
        );

            $scope.addNewRow = function (recordType) {
               var newRec = { 'name': '', 'value': '' };
               if (recordType == 'Account')
                   $scope.recordAccount.push(newRec);
               else if(recordType == 'Contact')
                   $scope.recordContact.push(newRec);
            }
            //$scope.addContactRow = function () {
            //    var newRec = { 'name': '', 'value': '' };
            //    $scope.recordContact.push(newRec);
            //}
            $scope.saveAccountMapping = function (recordAccount) {
                if (recordAccount.length > 0) {
                    angular.forEach(recordAccount, function (value, key) {
                        delete value.$$hashKey;
                    })
                }
                olbico.Engine.saveAccountMapping(JSON.stringify(recordAccount), function (result, event) {
                    if (result != null) {
                        $toaster.showSuccess("Account Mapping Updated Successfully");
                    }
                }, { escape: true });
      
            }

            $scope.saveContactMapping = function (recordContact) {
                if (recordContact.length > 0) {
                    angular.forEach(recordContact, function (value, key) {
                        delete value.$$hashKey;
                    })
                }
                olbico.Engine.saveContactMapping(JSON.stringify(recordContact), function (result, event) {
                    if (result != null) {
                        $toaster.showSuccess("Contact Mapping Updated Successfully");
                    }
                }, { escape: true });

            }
            $scope.saveInfo = function () {
                $scope.IsDisable = true;
                olbico.Engine.saveUserInfo($scope.username,$scope.password,$scope.IsAccount,$scope.IsContact,$scope.mapDuns, function (result, event) {
                    if (result != null && result == true) {
                        $toaster.showSuccess('Successfully Update');
                    } else {
                        $toaster.showError('Invalid Credential');
                    }

                }, { escape: true })
            }
            $scope.editInfo = function () {

                $scope.IsDisable = false;

            }
            $scope.removeRow = function (record,objType) {

                if (objType =='Account') {
                    var index = $scope.recordAccount.indexOf(record);
                    if(index>=0)
                        $scope.recordAccount.splice(index, 1);
                    }
                if (objType == 'Contact') {
                    var index = $scope.recordContact.indexOf(record);
                    if (index >= 0)
                        $scope.recordContact.splice(index, 1);

                }
            }
            $scope.cancelInfo = function () {
                $scope.IsDisable = true;
            }
            $scope.CancelMapping = function (typeOfMapping) {
                if (typeOfMapping == 'Contact')
                    $scope.recordContact = angular.copy($scope.recordContactTemp);
                if(typeOfMapping =='Account')
                    $scope.recordAccount = angular.copy($scope.recordAccountTemp);
                
            }
           
        }]}
})