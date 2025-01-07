public class JSONAlarms {
	
    public String id {get;set;} 
	public String externalId {get;set;} 
	public String name {get;set;} 
	public String pfVehicleId {get;set;} 
	public String type {get;set;} 
    public String make {get;set;}
	public String model {get;set;}
	public dateTime dateTime_Z {get;set;} // in json: dateTime
	public String providerType {get;set;} 
	public String metaDataProvider {get;set;} 
    public List<AlarmReeferDto> alarms {get;set;} 

	public JSONAlarms(JSONParser parser) {
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
					} else if (text == 'make') {
						make = parser.getText();
					} else if (text == 'model') {
						model = parser.getText();
					} else if (text == 'dateTime') {
						dateTime_Z = parser.getDateTimeValue();
					} else if (text == 'providerType') {
						providerType = parser.getText();
					} else if (text == 'metaDataProvider') {
						metaDataProvider = parser.getText();
                    } else if (text == 'alarms') {
						alarms = arrayOfAlarmReeferDto(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'JSONAlarms consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static List<JSONAlarms> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfJSONAlarms(parser);
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

    private static List<JSONAlarms> arrayOfJSONAlarms(System.JSONParser p) {
        List<JSONAlarms> res = new List<JSONAlarms>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new JSONAlarms(p));
        }
        return res;
    }
    
    public class AlarmReeferDto {
		public String alarmCode {get;set;} 
		public String description {get;set;} 
		public String severity {get;set;} 

		public AlarmReeferDto(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'alarmCode') {
							alarmCode = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'severity') {
							severity = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'AlarmReeferDto consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}        
	}
    
    
    private static List<AlarmReeferDto> arrayOfAlarmReeferDto(System.JSONParser p) {
        List<AlarmReeferDto> res = new List<AlarmReeferDto>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
           	res.add(new AlarmReeferDto(p));
        }
        return res;
    }
    
}