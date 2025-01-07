@isTest
public class JSONTelematicsDataTest {

    @isTest 
    static void jsonLowBattery_Test(){
        
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
        '    \"occurrences\": 1,'+  
        '    \"vitesseMilesPerHour\": 0,'+  
        '    \"vitesseKmh\": 0,'+  
        '    \"propbidon\": 0' +
		'}';
       
        JSONLowBattery r = JSONLowBattery.parse(json); 
    }
    
    @isTest 
    static void jsonBatteryVoltage_Test(){
        
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
            
        JSONBatteryVoltage.parse(json); 
    }
  
    @isTest 
    static void jsonEngineLightData_Test(){
        
        String json =  '{'
        + '    \"subject\": \"\",'
        + '    \"description\": \"Liste des DTC : \",'
        + '    \"parcId\": \"PF-85441\",'
        + '    \"occurrences\": 1,'
        + '    \"propBidon\": \"PF-85441\",'
        + '    \"parc\": {'
        + '        \"id\": \"PF-85441\",'
        + '        \"creationDate\": \"2021-12-20T14:58:00.824+00:00\",'
        + '        \"modificationDate\": \"2021-12-20T14:58:00.824+00:00\",'
        + '        \"parcId\": \"PF-85441\",'
        + '        \"codeCategorie\": \"VL\",'
        + '        \"dateMiseEnCirculation\": \"06-11-2018\",'
        + '        \"age\": \"3 ans  et 3 mois\",'
        + '        \"hayon\": false,'
        + '        \"dateDernierEntretien\": \"06-11-2018\",'
        + '        \"codeAgence\": \"030\",'
        + '        \"nomAgence\": \"LIEGE\",'
        + '        \"adresse\": \"avenue 54\",'
        + '        \"ville\": \"HERSTAL\",'
        + '        \"codePostal\": \"4040\",'
        + '        \"tel\": \"042280898\",'
        + '        \"ptac\": 2.48'
        + '    },'
        + '    \"gps\": {'
        + '        \"time\": \"2022-02-15T23:21:44.867Z\",'
        + '        \"latitude\": 50.6306889,'
        + '        \"longitude\": 5.885531119,'
        + '        \"headingDegrees\": 0,'
        + '        \"speedMilesPerHour\": 0,'
        + '        \"reverseGeo\": {'
        + '            \"formattedLocation\": \"16 Rue du Progres, Dison, Wallonie, 4821\"'
        + '        }'
        + '    },'
        + '    \"faultCodes\": {'
        + '        \"id\": \"620a50f19f120d000fdb748a\",'
        + '        \"externalId\": \"212014918914227\",'
        + '        \"name\": \"PF-85441\",'
        + '        \"pfVehicleId\": \"PF-85441\",'
        + '        \"type\": \"faultCodes\",'
        + '        \"canBusType\": \"CANBUS_PASSENGER_15765_29_500\",'
        + '        \"dateTime\": \"2022-02-14T12:53:31Z\",'
        + '        \"providerType\": \"Samsara\",'
        + '        \"metaDataProvider\": \"{}\",'
        + '        \"pendingDtcs\": [],'
        + '        \"confirmedDtcs\": ['
        + '            {'
        + '                \"dtcDescription\": \"Clutch Position Sensor Circuit \",'
        + '                \"dtcId\": 2053,'
        + '                \"dtcShortCode\": \"P0805\"'
        + '            }'
        + '        ],'
        + '        \"permanentDtcs\": [],'
        + '        \"checkEngineLightIsOn\": false,'
        + '        \"dtcJ1939\": null,'
        + '        \"emissionsIsOn\": null,'
        + '        \"protectIsOn\": null,'
        + '        \"stopIsOn\": null,'
        + '        \"warningIsOn\": null,'
        + '        \"protocol\": \"passenger\"'
        + '    }'
        + '}';
        JSONEngineLightData.parse(json);
    }
    
    
	@isTest 
    static void jsonFaultCodeLightData_Test(){
        
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
        + '        \"propBidon\": null,                            				'
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
        + '        \"stopIsOn\": false,                                       	'
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
        + '        \"checkEngineLightIsOn\": null,                            	'
        + '        \"dtcJ1939\": null,                                        	'
        + '        \"emissionsIsOn\": false,                                  	'
        + '        \"protectIsOn\": false,                                    	'
        + '        \"stopIsOn\": false,                                       	'
        + '        \"warningIsOn\": false,                                    	'
        + '        \"protocol\": \"j1939\"										'
        + '    }]																';
        
        JSONFaultCodes.parse(json);
	}
    
    @isTest 
    static void jsonEngineStateData_Test(){
        
        String json =  '	[{                                             		' +
'        \"id\": \"621deef39f120d000fde7b5a\",         	' +
'        \"externalId\": \"844424930226155\",          	' +
'        \"name\": \"PF-80284\",                       	' +
'        \"pfVehicleId\": \"PF-80284\",                	' +
'        \"type\": \"engineStates\",                   	' +
'        \"value\": \"On\",                            	' +
'        \"dateTime\": \"2022-03-01T10:00:42Z\",       	' +
'        \"providerType\": \"Samsara\",                	' +
'        \"metaDataProvider\": \"metaDataProvider\",    ' +
'        \"propbidon\": 0								' +
'    },                                            		' +
'    {                                             		' +
'        \"id\": \"621deeee9f120d000fde653e\",         	' +
'        \"externalId\": \"844424930226155\",          	' +
'        \"name\": \"PF-80284\",                       	' +
'        \"pfVehicleId\": \"PF-80284\",                	' +
'        \"type\": \"engineStates\",                   	' +
'        \"value\": \"On\",                            	' +
'        \"dateTime\": \"2022-03-01T10:00:42Z\",       	' +
'        \"providerType\": \"Samsara\",                	' +
'        \"metaDataProvider\": \"metaDataProvider\"	   	' +
'    }]											   		' ;
        
        JSONEngineState.parse(json);
	}
    
    @isTest 
    static void jsonGPSData_Test(){
        
        String json =  '	{                                             		' +
'        \"id\": \"621deef39f120d000fde7b5a\",         	' +
'        \"externalId\": \"844424930226155\",          	' +
'        \"name\": \"PF-80284\",                       	' +
'        \"pfVehicleId\": \"PF-80284\",                	' +
'        \"type\": \"engineStates\",                   	' +
'        \"value\": \"On\",                            	' +
'        \"latitude\": 50.6306889,						' +			
'        \"longitude\": 5.885531119,					' +        
'        \"dateTime\": \"2022-03-01T10:00:42Z\",       	' +
'        \"providerType\": \"Samsara\",                	' +
'        \"metaDataProvider\": \"metaDataProvider\"    	' +
'    }                                            		';
        
        JSONGPS.parse(json);
	}
    
    @isTest 
    static void jsonAlarms_Test(){
        String json = '['
				+ '    {'
				+ '        \"id\": \"60ffe7ba911a5d001999b4cd\",'
				+ '        \"externalId\": \"844424930168617\",'
				+ '        \"name\": \"PF-89279\",'
				+ '        \"pfVehicleId\": \"PF-89279\",'
				+ '        \"type\": \"alarms\",'
            	+ '        \"model\": \"Carrier EU\",'
            	+ '        \"make\": \"Xarios\",'
				+ '        \"dateTime\": \"2021-07-27T10:57:50Z\",'
				+ '        \"providerType\": \"Samsara\",'
				+ '        \"metaDataProvider\": \"\",'
            	+ '        \"alarms\": ['
            	+ '            {'
            	+ '                \"description\": \"Low pressure switch open \",'
            	+ '                \"alarmCode\": \"A01\",'
            	+ '                \"severity\": \"red\"'
            	+ '            }'
            	+ '        ]'
				+ '    },'
				+ '    {'
				+ '        \"id\": \"60ffe7c18b0d5b001009179c\",'
				+ '        \"externalId\": \"844424930168617\",'
				+ '        \"name\": \"PF-89279\",'
				+ '        \"pfVehicleId\": \"PF-89279\",'
				+ '        \"type\": \"alarms\",'
				+ '        \"value\": 25245,'
				+ '        \"dateTime\": \"2021-07-27T11:01:52Z\",'
				+ '        \"providerType\": \"Samsara\",'
				+ '        \"metaDataProvider\": \"\",'
            	+ '        \"propbidon\": 0,'
            	+ '        \"alarms\": ['
            	+ '            {'
            	+ '                \"description\": \"Low pressure switch open \",'
            	+ '                \"alarmCode\": \"A01\",'
            	+ '                \"severity\": \"red\"'
            	+ '            }'
            	+ '        ]'
				+ '    }]';
            
        JSONAlarms.parse(json);
    }
    
    @isTest 
    static void jsonAmbientAirTemperature_Test(){
        String json = '['
				+ '    {'
				+ '        \"id\": \"60ffe7ba911a5d001999b4cd\",'
				+ '        \"externalId\": \"844424930168617\",'
				+ '        \"name\": \"PF-89279\",'
				+ '        \"pfVehicleId\": \"PF-89279\",'
				+ '        \"type\": \"ambientAirTemperatureMilliC\",'
				+ '        \"value\": 25248,'
				+ '        \"dateTime\": \"2021-07-27T10:57:50Z\",'
				+ '        \"providerType\": \"Samsara\",'
				+ '        \"metaDataProvider\": \"\"'
				+ '    },'
				+ '    {'
				+ '        \"id\": \"60ffe7c18b0d5b001009179c\",'
				+ '        \"externalId\": \"844424930168617\",'
				+ '        \"name\": \"PF-89279\",'
				+ '        \"pfVehicleId\": \"PF-89279\",'
				+ '        \"type\": \"ambientAirTemperatureMilliC\",'
				+ '        \"value\": 25245,'
				+ '        \"dateTime\": \"2021-07-27T11:01:52Z\",'
				+ '        \"providerType\": \"Samsara\",'
				+ '        \"metaDataProvider\": \"\",'
            	+ '        \"propbidon\": 0'
				+ '    }]';
            
        JSONAmbientAirTemperature.parse(json);
    }
    
    @isTest 
    static void jsonLowPressureCutOffA01_Test(){
    	String json =  '{'
        + '    \"subject\": \"\",'
        + '    \"description\": \"Liste des DTC : \",'
        + '    \"parcId\": \"PF-85441\",'
        + '    \"parc\": {'
        + '        \"id\": \"PF-85441\",'
        + '        \"creationDate\": \"2021-12-20T14:58:00.824+00:00\",'
        + '        \"modificationDate\": \"2021-12-20T14:58:00.824+00:00\",'
        + '        \"parcId\": \"PF-85441\",'
        + '        \"codeCategorie\": \"VL\",'
        + '        \"dateMiseEnCirculation\": \"06-11-2018\",'
        + '        \"age\": \"3 ans  et 3 mois\",'
        + '        \"hayon\": false,'
        + '        \"dateDernierEntretien\": \"06-11-2018\",'
        + '        \"codeAgence\": \"030\",'
        + '        \"nomAgence\": \"LIEGE\",'
        + '        \"adresse\": \"avenue 54\",'
        + '        \"ville\": \"HERSTAL\",'
        + '        \"codePostal\": \"4040\",'
        + '        \"tel\": \"042280898\",'
        + '        \"ptac\": 2.48'
        + '    },'
        + '    \"gps\": {'
        + '        \"time\": \"2022-02-15T23:21:44.867Z\",'
        + '        \"latitude\": 50.6306889,'
        + '        \"longitude\": 5.885531119,'
        + '        \"headingDegrees\": 0,'
        + '        \"speedMilesPerHour\": 0,'
        + '        \"reverseGeo\": {'
        + '            \"formattedLocation\": \"16 Rue du Progres, Dison, Wallonie, 4821\"'
        + '        }'
        + '    },'
		+ '    \"occurrences\": 1,'
        + '    \"prop\": \"1\"'   
        + '}';
        
        JSONLowPressureCutOffA01.parse(json);
    }
}