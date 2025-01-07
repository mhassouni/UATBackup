@isTest
global class MockVoyantMoteurEvolutionHttpResponse implements HttpCalloutMock {
   // Implement this interface method
  global HTTPResponse respond(HTTPRequest req) {
    // Optionally, only send a mock response for a specific endpoint
    // and method.
    //System.assertEquals('http://example.com/example/test', req.getEndpoint());
    //System.assertEquals('GET', req.getMethod());
    
    String json =  '	[{                                                              	'
        + '        \"id\": \"62048c7b9f120d000f26d132\",                        '
        + '        \"externalId\": \"844424930184047\",                         '
        + '        \"name\": \"PF-58879\",                                      '
        + '        \"pfVehicleId\": \"PF-58879\",                               '
        + '        \"type\": \"faultCodes\",                                    '
        + '        \"canBusType\": \"CANBUS_J1939_250\",                        '
        + '        \"dateTime\": \"2022-02-10T03:53:24Z\",                      '
        + '        \"providerType\": \"Samsara\",                               '
        + '        \"metaDataProvider\": \"{}\",                                '
        + '        \"pendingDtcs\": null,                                     	'
        + '        \"confirmedDtcs\": null,                                   	'
        + '        \"permanentDtcs\": null,                                   	'
        + '        \"checkEngineLightIsOn\": null,                            	'
        + '        \"dtcJ1939\": [                                            	'
        + '            {                                                    	'
        + '                \"fmiDescription\": \"Current Below Normal\",        '
        + '                \"spnDescription\": \"spnDescription\",        '
        + '                \"sourceAddressName\": \"sourceAddressName\",        '
        + '                \"fmiId\": 5,                                      	'
        + '                \"milStatus\": 3,                                  	'
        + '                \"occurrenceCount\": 42,                           	'
        + '                \"spnId\": 159059,                                 	'
        + '                \"txId\": 109                                      	'
        + '            }                                                    	'
        + '        ],                                                       	'
        + '        \"emissionsIsOn\": true,                                   	'
        + '        \"protectIsOn\": true,                                     	'
        + '        \"stopIsOn\": true,                                       	'
        + '        \"warningIsOn\": true,                                     	'
        + '        \"protocol\": \"j1939\"                                      '
        + '    },                                                           	'
        + '    {                                                            	'
        + '        \"id\": \"620493389f120d000f2d3e0e\",                        '
        + '        \"externalId\": \"844424930184047\",                         '
        + '        \"name\": \"PF-58879\",                                      '
        + '        \"pfVehicleId\": \"PF-58879\",                               '
        + '        \"type\": \"faultCodes\",                                    '
        + '        \"canBusType\": \"CANBUS_J1939_250\",                        '
        + '        \"dateTime\": \"2022-02-10T04:23:15Z\",                      '
        + '        \"providerType\": \"Samsara\",                               '
        + '        \"metaDataProvider\": \"{}\",                                '
        + '        \"pendingDtcs\": null,                                     	'
        + '        \"confirmedDtcs\": null,                                   	'
        + '        \"permanentDtcs\": null,                                   	'
        + '        \"checkEngineLightIsOn\": false,                            	'
        + '        \"dtcJ1939\": null,                                        	'
        + '        \"emissionsIsOn\": false,                                  	'
        + '        \"protectIsOn\": false,                                    	'
        + '        \"stopIsOn\": false,                                       	'
        + '        \"warningIsOn\": false,                                    	'
        + '        \"protocol\": \"passenger\"										'
        + '    }]																';
      
    // Create a fake response
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody(json);
    res.setStatusCode(200);
    return res;
  }
}