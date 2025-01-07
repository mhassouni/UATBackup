({
    showToastMessage: function(component, response, title, variant) {
        $A.get("e.force:closeQuickAction").fire();
        let errorMsgObject = response.getError();
        let exceptionType = errorMsgObject[0].hasOwnProperty('exceptionType') ? errorMsgObject[0].exceptionType + '. ' : '';
        let stackTrace = errorMsgObject[0].hasOwnProperty('stackTrace') ? '. ' + errorMsgObject[0].stackTrace : '';
        let finalMessage = exceptionType + errorMsgObject[0].message + stackTrace;
        component.find('notifyId').showToast({
            variant: variant,
            title: title,
            message: finalMessage
        });
    },

    showToastMessageInSFClassic: function(component, response, title, variant) {
        let errorMsgObject = response.getError();
        let exceptionType = errorMsgObject[0].hasOwnProperty('exceptionType') ? errorMsgObject[0].exceptionType + '. ' : '';
        let stackTrace = errorMsgObject[0].hasOwnProperty('stackTrace') ? '. ' + errorMsgObject[0].stackTrace : '';
        let finalMessage = exceptionType + errorMsgObject[0].message + stackTrace;
        let sfClassicToastMessageSetup = {
            hasToastMessage: true, 
            messageTitle: title,
            messageSeverity: variant,
            message: finalMessage
        };
        component.set("v.sfClassicToastMessageSetup", sfClassicToastMessageSetup);
    }
})