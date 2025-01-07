public class JSONLowBattery {

	public String parcId {get;set;} 
	public String typeVehicule {get;set;} 
	public String ageVehicule {get;set;} 
	public Boolean hayon {get;set;} 
	public String typeDeBatterie {get;set;} 
	public Decimal tensionBatterie2H {get;set;} 
	public String chargeAlternateur {get;set;} 
	public String codeDefautAlternateur {get;set;} 
	public Integer temperatureExterieure {get;set;} 
	public Integer nbDemarrage12H {get;set;} 
	public Integer nbKilometres12HGPS {get;set;} 
	public Integer nbKilometres12HOBD {get;set;} 
	public Integer nbKilometres12H {get;set;} 
	public Gps gps {get;set;} 
	public BatteryMilliVolts batteryMilliVolts {get;set;} 
	public GpsOdometerMeters gpsOdometerMeters {get;set;} 
	public EngineStates engineStates {get;set;} 
	public GpsOdometerMeters ambientAirTemperatureMilliC {get;set;} 
	public GpsOdometerMeters obdOdometerMeters {get;set;} 
	public String faultCodeP2503 {get;set;} 
    public Integer vitesseMilesPerHour;
    public Integer vitesseKmh {get;set;}
    public Integer occurrences {get;set;}

	public JSONLowBattery(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'parcId') {
						parcId = parser.getText();
					} else if (text == 'typeVehicule') {
						typeVehicule = parser.getText();
					} else if (text == 'ageVehicule') {
						ageVehicule = parser.getText();
					} else if (text == 'hayon') {
						hayon = parser.getBooleanValue();
					} else if (text == 'typeDeBatterie') {
						typeDeBatterie = parser.getText();
					} else if (text == 'tensionBatterie2H') {
						tensionBatterie2H = parser.getDecimalValue();
                        /*if(tensionBatterie2H != null){
                            tensionBatterie2H = tensionBatterie2H.setScale(2, RoundingMode.HALF_UP);
                        }*/
					} else if (text == 'chargeAlternateur') {
						chargeAlternateur = parser.getText();
					} else if (text == 'codeDefautAlternateur') {
						codeDefautAlternateur = parser.getText();
					} else if (text == 'temperatureExterieure') {
						temperatureExterieure = parser.getIntegerValue();
					} else if (text == 'nbDemarrage12H') {
						nbDemarrage12H = parser.getIntegerValue();
					} else if (text == 'nbKilometres12HGPS') {
						nbKilometres12HGPS = parser.getIntegerValue();
					} else if (text == 'nbKilometres12HOBD') {
						nbKilometres12HOBD = parser.getIntegerValue();
					} else if (text == 'nbKilometres12H') {
						nbKilometres12H = parser.getIntegerValue();
					} else if (text == 'gps') {
						gps = new Gps(parser);
					} else if (text == 'batteryMilliVolts') {
						batteryMilliVolts = new BatteryMilliVolts(parser);
					} else if (text == 'gpsOdometerMeters') {
						gpsOdometerMeters = new GpsOdometerMeters(parser);
					} else if (text == 'engineStates') {
						engineStates = new EngineStates(parser);
					} else if (text == 'ambientAirTemperatureMilliC') {
						ambientAirTemperatureMilliC = new GpsOdometerMeters(parser);
					} else if (text == 'obdOdometerMeters') {
						obdOdometerMeters = new GpsOdometerMeters(parser);
					} else if (text == 'faultCodeP2503') {
						faultCodeP2503 = parser.getText();
                    } else if (text == 'vitesseMilesPerHour') {
						vitesseMilesPerHour = parser.getIntegerValue();                        
                    } else if (text == 'vitesseKmh') {
						vitesseKmh = parser.getIntegerValue();
                    } else if (text == 'occurrences') {
						occurrences = parser.getIntegerValue();                            
					} else {
						System.debug(LoggingLevel.WARN, 'JSONLowBattery consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class BatteryMilliVolts {
		public String id {get;set;} 
		public String externalId {get;set;} 
		public String name {get;set;} 
		public String pfVehicleId {get;set;} 
		public String type {get;set;} 
		public Decimal value_Z {get;set;}  // mot réservé value
		public dateTime dateTime_Z {get;set;} // in json: dateTime
		public String providerType {get;set;} 
		public String metaDataProvider {get;set;} 
		public Parc parc {get;set;} 
		public Integer lowBatteryOccurences {get;set;} 
		public String vehicleStatus {get;set;} 

		public BatteryMilliVolts(JSONParser parser) {
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
							value_Z  = parser.getDecimalValue();
                            /*if(value_Z != null){
                                value_Z = value_Z.setScale(2, RoundingMode.HALF_UP);
                            }*/
						} else if (text == 'dateTime') {
							dateTime_Z = parser.getDateTimeValue();
						} else if (text == 'providerType') {
							providerType = parser.getText();
						} else if (text == 'metaDataProvider') {
							metaDataProvider = parser.getText();
						} else if (text == 'parc') {
							parc = new Parc(parser);
						} else if (text == 'lowBatteryOccurences') {
							lowBatteryOccurences = parser.getIntegerValue();
						} else if (text == 'vehicleStatus') {
							vehicleStatus = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'BatteryMilliVolts consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Parc {
		public Object id {get;set;} 
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
							id = parser.readValueAs(Object.class);
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
	
	public class EngineStates {
		public String id {get;set;} 
		public String externalId {get;set;} 
		public String name {get;set;} 
		public String pfVehicleId {get;set;} 
		public String type {get;set;} 
		public String value {get;set;} 
		public dateTime dateTime_Z {get;set;} // in json: dateTime
		public String providerType {get;set;} 
		public String metaDataProvider {get;set;} 

		public EngineStates(JSONParser parser) {
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
							value = parser.getText();
						} else if (text == 'dateTime') {
							dateTime_Z = parser.getDateTimeValue();
						} else if (text == 'providerType') {
							providerType = parser.getText();
						} else if (text == 'metaDataProvider') {
							metaDataProvider = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'EngineStates consuming unrecognized property: '+text);
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
	
	public class GpsOdometerMeters {
		public String id {get;set;} 
		public String externalId {get;set;} 
		public String name {get;set;} 
		public String pfVehicleId {get;set;} 
		public String type {get;set;} 
		public Double value_Z {get;set;}  //nom reservé?
		public String dateTime_Z {get;set;} // in json: dateTime
		public String providerType {get;set;} 
		public String metaDataProvider {get;set;} 

		public GpsOdometerMeters(JSONParser parser) {
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
							value_Z = parser.getDoubleValue();
						} else if (text == 'dateTime') {
							dateTime_Z = parser.getText();
						} else if (text == 'providerType') {
							providerType = parser.getText();
						} else if (text == 'metaDataProvider') {
							metaDataProvider = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'GpsOdometerMeters consuming unrecognized property: '+text);
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
	
	
	public static JSONLowBattery parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new JSONLowBattery(parser);
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