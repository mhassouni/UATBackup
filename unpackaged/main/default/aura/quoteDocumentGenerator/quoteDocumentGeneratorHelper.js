({
	getParameterByName: function(component, event, name) {
        name = name.replace(/[\[\]]/g, "\\$&");
        var url = window.location.href;
        var regex = new RegExp("[?&]" + name + "(=1\.([^&#]*)|&|#|$)");
        var results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    },

    showToastMessage: function(component, response, title, variant) {
        $A.get("e.force:closeQuickAction").fire();
        let errorMsgObject = response.getError();
        let exceptionType = errorMsgObject[0].hasOwnProperty('exceptionType') ? errorMsgObject[0].exceptionType + '. ' : '';
        let stackTrace = errorMsgObject[0].hasOwnProperty('stackTrace') ? '. ' + errorMsgObject[0].stackTrace : '';
        let finalMessage = exceptionType + errorMsgObject[0].message + stackTrace;
        component.find('notifyId').showToast({
            variant: variant,
            title: variant == title,
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