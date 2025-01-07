public class JSONFaultCodes {
	
    public String id {get;set;} 
	public String externalId {get;set;} 
	public String name {get;set;} 
	public String pfVehicleId {get;set;} 
	public String type {get;set;} 
	//public Double value {get;set;} 
    public String canBusType {get;set;}
	public dateTime dateTime_Z {get;set;} // in json: dateTime
	public String providerType {get;set;} 
	public String metaDataProvider {get;set;} 
    public Boolean checkEngineLightIsOn {get;set;} 
    public Boolean protectIsOn {get;set;} 
    public Boolean stopIsOn {get;set;} 
    public Boolean warningIsOn {get;set;} 
    public Boolean emissionsIsOn {get;set;} 
    public String protocol {get;set;} 
    public List<PassengerDTCDto> pendingDtcs {get;set;} 
    public List<PassengerDTCDto> confirmedDtcs {get;set;} 
    public List<PassengerDTCDto> permanentDtcs {get;set;} 
    public List<J1939DTCDto> dtcJ1939 {get;set;} 

	public JSONFaultCodes(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'id') {
						id = parser.getText();
					} else if (text == 'externalId') {
						externalId = parser.getText();
					} else if (text == 'name') {
						name = parser.getText();
					} else if (text == 'pfVehicleId') {
						pfVehicleId = parser.getText();
					} else if (text == 'type') {
						type = parser.getText();
					//} else if (text == 'value') {
					//	value = parser.getDoubleValue();
					} else if (text == 'canBusType') {
						canBusType = parser.getText();
					} else if (text == 'dateTime') {
						dateTime_Z = parser.getDateTimeValue();
					} else if (text == 'providerType') {
						providerType = parser.getText();
					} else if (text == 'metaDataProvider') {
						metaDataProvider = parser.getText();
					} else if (text == 'checkEngineLightIsOn') {
						checkEngineLightIsOn = parser.getBooleanValue();
					} else if (text == 'protectIsOn') {
						protectIsOn = parser.getBooleanValue();
					} else if (text == 'warningIsOn') {
						warningIsOn = parser.getBooleanValue();
					} else if (text == 'stopIsOn') {
						stopIsOn = parser.getBooleanValue();
					} else if (text == 'emissionsIsOn') {
						emissionsIsOn = parser.getBooleanValue();
					} else if (text == 'protocol') {
						protocol = parser.getText();
                    } else if (text == 'pendingDtcs') {
						pendingDtcs = arrayOfPassengerDTCDto(parser);
                    } else if (text == 'confirmedDtcs') {
						confirmedDtcs = arrayOfPassengerDTCDto(parser);
                    } else if (text == 'permanentDtcs') {
						permanentDtcs = arrayOfPassengerDTCDto(parser);
                    } else if (text == 'dtcJ1939') {
						dtcJ1939 = arrayOfJ1939DTCDto(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSONFaultCodes consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static List<JSONFaultCodes> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfJSONFaultCodes(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}

    private static List<JSONFaultCodes> arrayOfJSONFaultCodes(System.JSONParser p) {
        List<JSONFaultCodes> res = new List<JSONFaultCodes>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new JSONFaultCodes(p));
        }
        return res;
    }
    
    public class PassengerDTCDto {
		public Integer dtcId {get;set;} 
		public String dtcShortCode {get;set;} 
		public String dtcDescription {get;set;} 

		public PassengerDTCDto(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'dtcId') {
							dtcId = parser.getIntegerValue();
						} else if (text == 'dtcShortCode') {
							dtcShortCode = parser.getText();
						} else if (text == 'dtcDescription') {
							dtcDescription = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'PassengerDTCDto consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}        
	}
    
    public class J1939DTCDto {
		public Integer fmiId {get;set;} 
		public String fmiDescription {get;set;} 
		public Integer spnId {get;set;} 
		public String spnDescription {get;set;} 
		public String sourceAddressName {get;set;} 
		public Integer milStatus {get;set;} 
		public Integer occurrenceCount {get;set;} 
		public Integer txId {get;set;} 
		

		public J1939DTCDto(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'fmiId') {
							fmiId = parser.getIntegerValue();
						} else if (text == 'fmiDescription') {
							fmiDescription = parser.getText();
						}else if (text == 'spnId') {
							spnId = parser.getIntegerValue();						
						} else if (text == 'spnDescription') {
							spnDescription = parser.getText();
						} else if (text == 'sourceAddressName') {
							sourceAddressName = parser.getText();
						}else if (text == 'milStatus') {
							milStatus = parser.getIntegerValue();		
						}else if (text == 'occurrenceCount') {
							occurrenceCount = parser.getIntegerValue();
						}else if (text == 'txId') {
							txId = parser.getIntegerValue();		
						} else {
							System.debug(LoggingLevel.WARN, 'J1939DTCDto consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}        
	}
    
    private static List<PassengerDTCDto> arrayOfPassengerDTCDto(System.JSONParser p) {
        List<PassengerDTCDto> res = new List<PassengerDTCDto>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
           	res.add(new PassengerDTCDto(p));
        }
        return res;
    }
    
    private static List<J1939DTCDto> arrayOfJ1939DTCDto(System.JSONParser p) {
        List<J1939DTCDto> res = new List<J1939DTCDto>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
           	res.add(new J1939DTCDto(p));
        }
        return res;
    }
}