/*
	Name : engine.js
	Description : Service for database transaction
	CreatedBy : Ajaysinh Chauhan
*/
//Ashish Lokhande
angular.module('salesforce', [])
.factory('$salesforce', ['$toaster', function ($error) {
    var $engine = {
        invoke: function () {
            var onsuccess = arguments[arguments.length - 2];
            var onerror = arguments[arguments.length - 1];
            arguments[arguments.length - 2] = function (result, event) {
                if (event.status)
                    onsuccess.apply(this, arguments);
                else {
                    if (onerror)
                        onerror.call(this, event.message);
                    else
                        $error.showError(event.message);
                }
            };

            arguments[arguments.length - 1] = function (result, event) {
                if (onerror)
                    onerror.call(this, event.message);
                else
                    $error.showError(event.message);
            };

            arguments[arguments.length] = { buffer: false, escape: false, timeout: 120000 };
            ++arguments.length;
            Visualforce.remoting.Manager.invokeAction.apply(Visualforce.remoting.Manager, arguments);
        },
        deactivateUser: function (struserId, onsuccess, onerror) {
            $engine.invoke("Engine.deactivateUser", struserId, onsuccess, onerror);
        },
        query: function (query, onsuccess, onerror) {
            $engine.invoke("Engine.query", query, onsuccess, onerror);
        },
        saveRecord: function (record, onsuccess, onerror) {
            $engine.invoke("Engine.saveRecord", record, onsuccess, onerror);
        },
        saveRecords: function (record, onsuccess, onerror) {
            $engine.invoke("Engine.saveRecords", record, onsuccess, onerror);
        },
        saveContacts: function (record, onsuccess, onerror) {
            $engine.invoke("Engine.saveContacts", record, onsuccess, onerror);
        },
        deleteRecord: function (record, onsuccess, onerror) {
            $engine.invoke("Engine.deleteRecord", record, onsuccess, onerror);
        },
        deleteRecords: function (record, onsuccess, onerror) {
            $engine.invoke("Engine.deleteRecords", record, onsuccess, onerror);
        },
        getPicklistValues: function (record, onsuccess, onerror) {
            $engine.invoke("Engine.getPicklistValues", record, onsuccess, onerror);
        },
        createAttachment: function (attachmentObject, onSuccessOnError) {
            sforce.connection.create([attachmentObject], onSuccessOnError);
        },
        getMapRecordTypes: function (onsuccess, onerror) {
            $engine.invoke("Engine.getMapRecordTypes", onsuccess, onerror);
        },
        saveOrganisationRegistration: function (objAccount, objContact, onsuccess, onerror) {
            $engine.invoke("Engine.saveOrganisationRegistration", objAccount, objContact, onsuccess, onerror);
        },
        saveEmergencyGrant: function (objAccount, objOpportunity, objContact, objApplicantContact, childrens, onsuccess, onerror) {
            $engine.invoke("Engine.saveEmergencyGrant", objAccount, objOpportunity, objContact, objApplicantContact, childrens, onsuccess, onerror);
        },
        saveChildrensOrganisationGrant: function (objAccount, objOpportunity, objContact, onsuccess, onerror) {
            $engine.invoke("Engine.saveChildrensOrganisationGrant", objAccount, objOpportunity, objContact, onsuccess, onerror);
        },
        saveOldPeoplesOrganisationGrant: function (onsuccess, onerror) {
            //$engine.invoke("Engine.saveOldPeoplesOrganisationGrant", onsuccess, onerror);
        },
        saveAlmsHospiceOrganisationGrant: function (onsuccess, onerror) {
            //$engine.invoke("Engine.saveAlmsHospiceOrganisationGrant", onsuccess, onerror);
        },
        saveTwiceYearlyGrantNew: function (objAccount, objContact, objApplicantContact, objOpportunity, lstChildrens, onsuccess, onerror) {
            $engine.invoke("Engine.saveTwiceYearlyGrantNew", objAccount, objContact, objApplicantContact, objOpportunity, lstChildrens, onsuccess, onerror);
        },
        saveTwiceYearlyGrantReapp: function (objAccount, objContact, objApplicantContact, objOpportunity, onsuccess, onerror) {
            $engine.invoke("Engine.saveTwiceYearlyGrantReapp", objAccount, objContact, objApplicantContact, objOpportunity, onsuccess, onerror);
        },
        upload: function (name, contentType, parentId, body, onsuccess, onerror) {
            $engine.invoke("Engine.upload", name, contentType, parentId, body, onsuccess, onerror);
        },
        uploadAttachment: function (name, contentType, parentId, attachmentNo, body, onsuccess, onerror) {
            $engine.invoke("Engine.uploadAttachment", name, contentType, parentId, attachmentNo, body, onsuccess, onerror);
        },
        remoteLogin: function (username, password, startUrl, onsuccess, onerror) {
            $engine.invoke("Engine.remoteLogin", username, password, startUrl, onsuccess, onerror);
        },
        sendApplicationSubmissionEmail: function (strAccountName, onsuccess, onerror) {
            $engine.invoke("Engine.sendApplicationSubmissionEmail", strAccountName, onsuccess, onerror);
        },
        remoteForgotpass: function (username, onsuccess, onerror) {
            $engine.invoke("Engine.remoteForgotpass", username, onsuccess, onerror);
        },
        leadFields: function (test, onsuccess, onerror) {
            $engine.invoke("Engine.saveDetails", test, onsuccess, onerror);
        }
    };
    return $engine;
}])