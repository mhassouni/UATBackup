/*
	Name : service-factory.js
	Description : Service for common use
	CreatedBy : Ashish Lokhande
*/
angular.module("service-factory", ['toaster'])
.factory("$toaster", function (toaster, $rootScope, $compile) {
    var $error = {
        showMessage: function (type, title, message, trusted) {
            var timeOut = (type == 'error') ? 0 : (type == 'success') ? 3000 : (type == 'info') ? 10000 : '';
            toaster.pop(type, title, message, timeOut, (trusted) ? 'trustedHtml' : '');
        },
        showError: function (message, title, trusted) {
            toaster.pop('error', title, message, 0, (trusted) ? 'trustedHtml' : '');
            if (!$error.scope.$$phase)
                $error.scope.$apply();
        },
        showSuccess: function (message, title, trusted) {
            toaster.pop('success', title, message, 0, (trusted) ? 'trustedHtml' : '');
            if (!$error.scope.$$phase)
                $error.scope.$apply();
        },
        showWarning: function (message, title, trusted) {
            toaster.pop('warning', title, message, 0, (trusted) ? 'trustedHtml' : '');
            if (!$error.scope.$$phase)
                $error.scope.$apply();
        },
        showInfo: function (message, title, trusted) {
            toaster.pop('info', title, message, 5000, (trusted) ? 'trustedHtml' : '');
            if (!$error.scope.$$phase)
                $error.scope.$apply();
        }
    };
    if ($(document).children('toaster-container').length <= 0) {
        var toasterContainer = angular.element('<toaster-container toaster-options="{\'close-button\':true}"></toaster-container>');
        toasterContainer = $compile(toasterContainer)($rootScope);
        $error.scope = toasterContainer.scope();
        $('body').append(toasterContainer);
    }
    return $error;
})
.factory("$loader", function () {
    var loader = {
        getLoader: function () {
            if ($("#loadingContainer").length == 0) {
                $('body').append('<div id="loadingContainer"><img class="loader" src="' + application_css + "images/ring.gif" + '"/><p style="font-family: solid; font-size: 25px; color: white;">Loading..</p></div>');
                $("#loadingContainer").hide();
            }
        },
        showProcessing: function () {
            $("#loadingContainer").show();
        },
        hideProcessing: function () {
            $("#loadingContainer").hide();
        }
    }
    return loader;
})

.service('$Utils', [function () {
    this.isUndefinedOrNull = function (value) {
        return angular.isUndefined(value) || value == null;
    }

    this.isUndefinedOrNullOrEmpty = function (value) {
        return angular.isUndefined(value) || value == null || value === "";
    }

    this.isNullOrEmpty = function (value) {
        return value == null || angular.isUndefined(value.length) || value.length === 0;
    }

    this.isObjNullOrEmpty = function (value) {
        return value == null || Object.keys(value).length === 0;
    }

    this.getParameterByName = function (name, url) {
        if (!url) {
            url = window.location.href;
        }
        name = name.replace(/[\[\]]/g, "\\$&");
        var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
			results = regex.exec(url);
        if (!results) return null;
        if (!results[2]) return '';
        return decodeURIComponent(results[2].replace(/\+/g, " "));
    }
}])