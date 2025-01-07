@isTest
global class MockBatteryEvolutionHttpResponse implements HttpCalloutMock {
   // Implement this interface method
  global HTTPResponse respond(HTTPRequest req) {
    // Optionally, only send a mock response for a specific endpoint
    // and method.
    //System.assertEquals('http://example.com/example/test', req.getEndpoint());
    //System.assertEquals('GET', req.getMethod());
    
    String json = '['
				+ '    {'
				+ '        \"id\": \"60ffe7ba911a5d001999b4cd\",'
				+ '        \"externalId\": \"844424930168617\",'
				+ '        \"name\": \"PF-89279\",'
				+ '        \"pfVehicleId\": \"PF-89279\",'
				+ '        \"type\": \"batteryMilliVolts\",'
				+ '        \"value\": 25248,'
				+ '        \"dateTime\": \"2021-07-27T10:57:50Z\",'
				+ '        \"providerType\": \"Samsara\",'
				+ '        \"metaDataProvider\": \"{\\\"batteryMilliVolts\\\":{\\\"time\\\":\\\"2021-07-27T10:57:50Z\\\",\\\"value\\\":25248.0}}\"'
				+ '    },'
				+ '    {'
				+ '        \"id\": \"60ffe7c18b0d5b001009179c\",'
				+ '        \"externalId\": \"844424930168617\",'
				+ '        \"name\": \"PF-89279\",'
				+ '        \"pfVehicleId\": \"PF-89279\",'
				+ '        \"type\": \"batteryMilliVolts\",'
				+ '        \"value\": 25245,'
				+ '        \"dateTime\": \"2021-07-27T11:01:52Z\",'
				+ '        \"providerType\": \"Samsara\",'
				+ '        \"metaDataProvider\": \"{\\\"batteryMilliVolts\\\":{\\\"time\\\":\\\"2021-07-27T11:01:52Z\\\",\\\"value\\\":25245.0}}\",'
            	+ '        \"propbidon\": 0'
				+ '    }]';
      
    // Create a fake response
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody(json);
    res.setStatusCode(200);
    return res;
  }
}