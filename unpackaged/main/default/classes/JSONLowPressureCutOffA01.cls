public class JSONLowPressureCutOffA01 {
	public String parcId {get;set;} 
	public String subject {get;set;} 
	public String description {get;set;}
    public Parc parc {get;set;}
	public Gps gps {get;set;} 
    public Integer occurrences {get;set;}
    
    public JSONLowPressureCutOffA01(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'parcId') {
						parcId = parser.getText();
					} else if (text == 'subject') {
						subject = parser.getText();
					} else if (text == 'description') {
						description = parser.getText();
					} else if (text == 'parc') {
						parc = new Parc(parser);
					} else if (text == 'gps') {
						gps = new Gps(parser);
                    } else if (text == 'occurrences') {
						occurrences = parser.getIntegerValue();                            					
					} else {
						System.debug(LoggingLevel.WARN, 'JSONLowPressureCutOffA01 consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
    
    public class Parc {
		public String id {get;set;} 
		public String creationDate {get;set;} 
		public String modificationDate {get;set;} 
		public String parcId {get;set;} 
		public String codeCategorie {get;set;} 
		public String dateMiseEnCirculation {get;set;} 
		public String age {get;set;} 
		public Boolean hayon {get;set;} 
		public String dateDernierEntretien {get;set;} 
		public String codeAgence {get;set;} 
		public String nomAgence {get;set;} 
		public String adresse {get;set;} 
		public String ville {get;set;} 
		public String codePostal {get;set;} 
		public String tel {get;set;} 
		public Double ptac {get;set;} 

		public Parc(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'id') {
							id = parser.getText();
						} else if (text == 'creationDate') {
							creationDate = parser.getText();
						} else if (text == 'modificationDate') {
							modificationDate = parser.getText();
						} else if (text == 'parcId') {
							parcId = parser.getText();
						} else if (text == 'codeCategorie') {
							codeCategorie = parser.getText();
						} else if (text == 'dateMiseEnCirculation') {
							dateMiseEnCirculation = parser.getText();
						} else if (text == 'age') {
							age = parser.getText();
						} else if (text == 'hayon') {
							hayon = parser.getBooleanValue();
						} else if (text == 'dateDernierEntretien') {
							dateDernierEntretien = parser.getText();
						} else if (text == 'codeAgence') {
							codeAgence = parser.getText();
						} else if (text == 'nomAgence') {
							nomAgence = parser.getText();
						} else if (text == 'adresse') {
							adresse = parser.getText();
						} else if (text == 'ville') {
							ville = parser.getText();
						} else if (text == 'codePostal') {
							codePostal = parser.getText();
						} else if (text == 'tel') {
							tel = parser.getText();
						} else if (text == 'ptac') {
							ptac = parser.getDoubleValue();
						} else {
							System.debug(LoggingLevel.WARN, 'Parc consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
    
    public class Gps {
		public String time_Z {get;set;} // in json: time
		public Double latitude {get;set;} 
		public Double longitude {get;set;} 
		public Integer headingDegrees {get;set;} 
		public Integer speedMilesPerHour {get;set;} 
		public ReverseGeo reverseGeo {get;set;} 

		public Gps(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'time') {
							time_Z = parser.getText();
						} else if (text == 'latitude') {
							latitude = parser.getDoubleValue();
						} else if (text == 'longitude') {
							longitude = parser.getDoubleValue();
						} else if (text == 'headingDegrees') {
							headingDegrees = parser.getIntegerValue();
						} else if (text == 'speedMilesPerHour') {
							speedMilesPerHour = parser.getIntegerValue();
						} else if (text == 'reverseGeo') {
							reverseGeo = new ReverseGeo(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'Gps consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
    
    public class ReverseGeo {
		public String formattedLocation {get;set;} 

		public ReverseGeo(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'formattedLocation') {
							formattedLocation = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'ReverseGeo consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
    
    public static JSONLowPressureCutOffA01 parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new JSONLowPressureCutOffA01(parser);
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
}