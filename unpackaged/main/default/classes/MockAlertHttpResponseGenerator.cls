@isTest
global class MockAlertHttpResponseGenerator implements HttpCalloutMock {
   // Implement this interface method
  global HTTPResponse respond(HTTPRequest req) {
    // Optionally, only send a mock response for a specific endpoint
    // and method.
    //System.assertEquals('http://example.com/example/test', req.getEndpoint());
    //System.assertEquals('GET', req.getMethod());
    
      String json = '{'+
		'    \"parcId\": \"PF-90841\",'+
		'    \"typeVehicule\": \"PL\",'+
		'    \"ageVehicule\": \"1 ans  et 6 mois\",'+
		'    \"hayon\": true,'+
		'    \"typeDeBatterie\": \"24 Volts\",'+
		'    \"tensionBatterie2H\": 0.0,'+
		'    \"chargeAlternateur\": \"-\",'+
		'    \"codeDefautAlternateur\": \"Non détecté.\",'+
		'    \"temperatureExterieure\": 20,'+
		'    \"nbDemarrage12H\": 1,'+
		'    \"nbKilometres12HGPS\": 0,'+
		'    \"nbKilometres12HOBD\": 0,'+
		'    \"nbKilometres12H\": 10,'+
		'    \"gps\": {'+
		'        \"time\": \"2021-07-13T16:16:08.001Z\",'+
		'        \"latitude\": 50.63698509,'+
		'        \"longitude\": 2.981092499,'+
		'        \"headingDegrees\": 0,'+
		'        \"speedMilesPerHour\": 0,'+
		'        \"reverseGeo\": {'+
		'            \"formattedLocation\": \"Avenue de l\'Europe, Lille, Hauts-de-France, 59160\"'+
		'        }'+
		'    },'+
		'    \"batteryMilliVolts\": {'+
		'        \"id\": \"60ede058c577c4000db44db2\",'+
		'        \"externalId\": \"844424930162516\",'+
		'        \"name\": \"PF-90841\",'+
		'        \"pfVehicleId\": \"PF-90841\",'+
		'        \"type\": \"batteryMilliVolts\",'+
		'        \"value\": 0.0,'+
		'        \"dateTime\": \"2021-07-13T16:21:07Z\",'+
		'        \"providerType\": \"Samsara\",'+
		'        \"metaDataProvider\": \"{\\\"batteryMilliVolts\\\":{\\\"time\\\":\\\"2021-07-13T16:21:07Z\\\",\\\"value\\\":0.0}}\",'+
		'        \"parc\": {'+
		'            \"id\": null,'+
		'            \"creationDate\": \"2021-03-30T12:37:53.096+00:00\",'+
		'            \"modificationDate\": \"2021-04-26T16:38:18.972+00:00\",'+
		'            \"parcId\": \"PF-90841\",'+
		'            \"codeCategorie\": \"PL\",'+
		'            \"dateMiseEnCirculation\": \"04-10-2019\",'+
		'            \"age\": \"1 ans  et 6 mois\",'+
		'            \"hayon\": true,'+
		'            \"dateDernierEntretien\": \"04-10-2019\",'+
		'            \"codeAgence\": \"014\",'+
		'            \"nomAgence\": \"LILLE\",'+
		'            \"adresse\": \"4 RUE DE L\'EUROPESAC POSTAL 7\",'+
		'            \"ville\": \"LOMME\",'+
		'            \"codePostal\": \"59160\",'+
		'            \"tel\": \"03 20 09 73 09\",'+
		'            \"ptac\": 16.0'+
		'        },'+
		'        \"lowBatteryOccurences\": 6,'+
		'        \"vehicleStatus\": \"MOTEUR_NON_TOURNANT\"'+
		'    },'+
		'    \"gpsOdometerMeters\": {'+
		'        \"id\": \"60ede046c577c4000db43379\",'+
		'        \"externalId\": \"844424930162516\",'+
		'        \"name\": \"PF-90841\",'+
		'        \"pfVehicleId\": \"PF-90841\",'+
		'        \"type\": \"gpsOdometerMeters\",'+
		'        \"value\": 7.4342009E7,'+
		'        \"dateTime\": \"2021-07-13T16:21:07Z\",'+
		'        \"providerType\": \"Samsara\",'+
		'        \"metaDataProvider\": \"{\\\"gpsOdometerMeters\\\":{\\\"time\\\":\\\"2021-07-13T16:21:07Z\\\",\\\"value\\\":7.4342009E7}}\"'+
		'    },'+
		'    \"engineStates\": {'+
		'        \"id\": \"60eddf3cc1486e000f7e45cc\",'+
		'        \"externalId\": \"844424930162516\",'+
		'        \"name\": \"PF-90841\",'+
		'        \"pfVehicleId\": \"PF-90841\",'+
		'        \"type\": \"engineStates\",'+
		'        \"value\": \"Off\",'+
		'        \"dateTime\": \"2021-07-13T16:15:58Z\",'+
		'        \"providerType\": \"Samsara\",'+
		'        \"metaDataProvider\": \"{\\\"engineStates\\\":{\\\"time\\\":\\\"2021-07-13T16:15:58Z\\\",\\\"value\\\":\\\"Off\\\"}}\"'+
		'    },'+
		'    \"ambientAirTemperatureMilliC\": {'+
		'        \"id\": \"60ede108c1486e000f7e57a8\",'+
		'        \"externalId\": \"844424930162516\",'+
		'        \"name\": \"PF-90841\",'+
		'        \"pfVehicleId\": \"PF-90841\",'+
		'        \"type\": \"ambientAirTemperatureMilliC\",'+
		'        \"value\": 20594.0,'+
		'        \"dateTime\": \"2021-07-13T16:15:58Z\",'+
		'        \"providerType\": \"Samsara\",'+
		'        \"metaDataProvider\": \"{\\\"ambientAirTemperatureMilliC\\\":{\\\"time\\\":\\\"2021-07-13T16:15:58Z\\\",\\\"value\\\":20594.0}}\"'+
		'    },'+
		'    \"obdOdometerMeters\": {'+
		'        \"id\": \"60edae8fcf7a1d000f451d9f\",'+
		'        \"externalId\": \"844424930162516\",'+
		'        \"name\": \"PF-90841\",'+
		'        \"pfVehicleId\": \"PF-90841\",'+
		'        \"type\": \"obdOdometerMeters\",'+
		'        \"value\": 7.42102E7,'+
		'        \"dateTime\": \"2021-07-13T12:39:06Z\",'+
		'        \"providerType\": \"Samsara\",'+
		'        \"metaDataProvider\": \"{\\\"obdOdometerMeters\\\":{\\\"time\\\":\\\"2021-07-13T12:39:06Z\\\",\\\"value\\\":7.42102E7}}\"'+
		'    },'+
		'    \"faultCodeP2503\": \"-\",'+
        '    \"propbidon\": 0' +
		'}';
      
    // Create a fake response
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody(json);
    res.setStatusCode(200);
    return res;
  }
}