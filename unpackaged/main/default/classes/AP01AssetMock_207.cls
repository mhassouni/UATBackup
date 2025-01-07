@istest
global with sharing class AP01AssetMock_207 implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"DateEffetReleveNotValid":"Soemthing"}');
        response.setStatusCode(207);
        return response;
    }
    

}