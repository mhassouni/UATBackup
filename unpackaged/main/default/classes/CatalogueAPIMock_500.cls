@istest
global with sharing class CatalogueAPIMock_500 implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"body":"Soemthing"}');
        response.setStatusCode(500);
        return response;
    }
    

}