public class JSONBatteryVoltage {

	public String id {get;set;} 
	public String externalId {get;set;} 
	public String name {get;set;} 
	public String pfVehicleId {get;set;} 
	public String type {get;set;} 
	public Double value {get;set;} 
	public dateTime dateTime_Z {get;set;} // in json: dateTime
	public String providerType {get;set;} 
	public String metaDataProvider {get;set;} 

	public JSONBatteryVoltage(JSONParser parser) {
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
					} else if (text == 'value') {
						value = parser.getDoubleValue();
					} else if (text == 'dateTime') {
						dateTime_Z = parser.getDateTimeValue();
					} else if (text == 'providerType') {
						providerType = parser.getText();
					} else if (text == 'metaDataProvider') {
						metaDataProvider = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'JSONBatteryVoltage consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	
	public static List<JSONBatteryVoltage> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfJSONBatteryVoltage(parser);
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
	



    private static List<JSONBatteryVoltage> arrayOfJSONBatteryVoltage(System.JSONParser p) {
        List<JSONBatteryVoltage> res = new List<JSONBatteryVoltage>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new JSONBatteryVoltage(p));
        }
        return res;
    }


}