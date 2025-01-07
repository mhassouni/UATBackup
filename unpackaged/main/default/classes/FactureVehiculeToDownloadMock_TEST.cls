@istest
global with sharing class FactureVehiculeToDownloadMock_TEST implements HttpCalloutMock {
	
    private Integer statusCode;
    
    // Constructor
    
    public FactureVehiculeToDownloadMock_TEST(Integer statusCode){
        this.statusCode = statusCode;
    }
    
    // Generate the RESTFUL Method
    
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Result":"JVBERi0xVPRgo="}');
        response.setStatusCode(this.statusCode);
        return response;
    }
    
}