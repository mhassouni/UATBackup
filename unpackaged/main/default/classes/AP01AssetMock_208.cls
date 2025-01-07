@istest
global with sharing class AP01AssetMock_208 implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"KmCompteurNotValid":"TEXT"}');
        response.setStatusCode(208);
        return response;
    }

}