angular.module('directive-factory',[])

.directive('siteHeader', function () {
    return {
        restrict: "E",
        templateUrl: application_js + "templates/siteHeader.html",
        scope: {
            imgUrl: '@'
        },
        controller: ["$scope", function ($scope) {
            $scope.headerUrl = application_css + "images/home-bg-01.jpg";
            console.log('header image::' + $scope.headerUrl);
        }]
    }

})