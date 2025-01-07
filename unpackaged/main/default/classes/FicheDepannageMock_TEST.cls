@istest
global with sharing class FicheDepannageMock_TEST implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"KmCompteurNotValid":"jhgjhgjhg"}');
        response.setStatusCode(200);
        return response;
    }
    

}