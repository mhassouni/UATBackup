public class PRG_AlertGoogleController {

public static JSONLowBattery JSonLOwBat {get; set;}    

    public  class location{
       //string  Street {get;set;}
       //string  City{get;set;}
       //string  State{get;set;}
       string Latitude {get;set;}
       string Longitude {get;set;}
       string LastLatitude {get;set;}
       string LastLongitude {get;set;} 
    }
    
    @AuraEnabled
    public static string  CurrentLocation(string precord){

       Alerte__c alert =[SELECT  id, Parc_Id__c ,Location_Latitude__c,Location_Longitude__c, parc__r.name 
                         FROM alerte__c where id= :precord LIMIT 1 ];
        location l = new  Location();
        l.Latitude =     string.valueof(alert.Location_Latitude__c);
        l.Longitude =    string.valueof(alert.Location_Longitude__c);
        //System.debug(l);
        
        String parcId = alert.parc__r.name;   
        String AlertVehiculeName =EncodingUtil.urlEncode(parcId,'UTF-8');
        
        String message = ' vide';
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        String sbx = UserInfo.getUserName().substringAfterLast('.');        
		System.debug(LoggingLevel.info, 'sandbox : ' + sbx);

		WebserviceTelematicsData__c ws = [Select name, Endpoint__c, Authorization__c, Environnement__c, Sandbox__c 
                                  FROM WebserviceTelematicsData__c limit 1];
        if(Test.isRunningTest()) {
            ws = [Select name, Endpoint__c, Authorization__c, Environnement__c, Sandbox__c 
                                  FROM WebserviceTelematicsData__c WHERE Sandbox__c = 'infra' limit 1];
        }
        
        string urlEndpoint = ws.Endpoint__c + '/gps/lastPosition?vehicleId=';
        req.setEndpoint(urlEndpoint+AlertVehiculeName+'');
        req.setMethod('GET');
        
        req.setHeader('Authorization', ws.Authorization__c);
       
        System.debug(LoggingLevel.info, 'urlEndpoint : ' + urlEndpoint);
        System.debug(LoggingLevel.info, 'PRGDebug : Envoi requête...');
        
        HttpResponse resp= new HttpResponse();
        req.setTimeout(30000);
        resp = http.send(req);
        System.debug(LoggingLevel.info, 'PRGDebug : resp.getStatusCode() : ' + resp.getStatusCode());
        
        if(resp.getStatusCode()==200)
        {
           system.debug(LoggingLevel.info, resp.getBody());
            message= 'ok ! '+ string.valueof(resp.getBody());
            
            JsonGPS gpsData = JsonGPS.parse(resp.getBody());
            if(gpsData != null){
                l.LastLatitude = string.valueof(gpsData.latitude);
                l.LastLongitude = string.valueof(gpsData.longitude);
                System.debug(LoggingLevel.info, 'LastLatitude : ' + l.LastLatitude);
                System.debug(LoggingLevel.info, 'LastLongitude : ' + l.LastLongitude);             
            }
        }
        
        return JSON.serialize(l); 
    }
        
    
    @AuraEnabled
    public static string RefreshLowBattery(string precord){

        Alerte__c alert = [SELECT  id, Parc_Id__c ,
                            Tension_Batterie_2H_Update__c,
                            Nb_Demarrages_12H_Update__c ,
                            Nb_Kilometres_12H_Update__c ,
                            Niveau_Batterie_Actuel_Update__c,
                            Temperature_Exterieure_Update__c,
                            Charge_Alternateur_Update__c,
                          	Dernier_Etat_Moteur__c,
                            Date_Dernier_Etat_Moteur_Update__c,
                          	Code_defaut_alternateur_update__c,
                          	Vitesse_Du_Vehicule_Update__c,
                            voyant_moteur_protocole__c, 
                            voyant_moteur_sujet__c, 
                            voyant_moteur_description__c,
                          	voyant_moteur_protocole_Update__c, 
                            voyant_moteur_sujet_Update__c, 
                            voyant_moteur_description_Update__c,
                          	Voyant_moteur_allume_depuis__c,
                            Voyant_moteur_allume_depuis_update__c,
                           	Occurrences__c,
                          	CreatedDate,
                           	parc__r.name,
                           	recordTypeId,
                           	DateTime_Alerte__c,
                           	Sujet__c,
                           	Description__c,
                           	Sujet_Update__c,
                           	Description_Update__c
                          	//Type_Alerte__c
                            FROM alerte__c where id= :precord LIMIT 1 ];
        
        String parcId = alert.parc__r.name;        
        System.debug(LoggingLevel.info, 'Asset name  : ' + parcId);  
        
        RecordType RecordType = [select Id, name from RecordType where id =: alert.recordTypeId ];
        String typeAlerte = RecordType.name;
        System.debug(LoggingLevel.info, 'typeAlerte  : ' + typeAlerte);  
        
        String AlertVehiculeName =EncodingUtil.urlEncode(parcId,'UTF-8');
        String AlerteDate= string.valueof((Datetime.now().formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'')));
        System.debug('PRGDebug : AlerteDate : ' + AlerteDate);
        AlerteDate= EncodingUtil.urlEncode(AlerteDate,'UTF-8');
      
        
        String message = ' vide';
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        //BON REQUETE 
        //string urlEndpoint = 'https://data-iot-mcs-5unavwdk4q-ew.a.run.app/lowBattery?vehicleName=';
        //string urlEndpoint = 'https://data-iot-mcs-5unavwdk4q-ew.a.run.app/secured/basic/lowBattery?vehicleName=';
        String sbx = UserInfo.getUserName().substringAfterLast('.');        
		System.debug(LoggingLevel.info, 'sandbox : ' + sbx);

		WebserviceTelematicsData__c ws = [Select name, Endpoint__c, Authorization__c, Environnement__c, Sandbox__c 
                                  FROM WebserviceTelematicsData__c limit 1];
        if(Test.isRunningTest()) {
            ws = [Select name, Endpoint__c, Authorization__c, Environnement__c, Sandbox__c 
                                  FROM WebserviceTelematicsData__c WHERE Sandbox__c = 'infra' limit 1];
        }
        
        string urlEndpoint = ws.Endpoint__c + '/lowBattery?vehicleName=';
        
        if(typeAlerte == 'Voyant moteur'){
            urlEndpoint = ws.Endpoint__c + '/engineLight?vehicleName=';
        }else if(typeAlerte == 'Coupure basse pression'){
            urlEndpoint = ws.Endpoint__c + '/lowPressureCutOffA01?vehicleName=';
        }
        
        req.setEndpoint(urlEndpoint+AlertVehiculeName+'&dateTime='+AlerteDate+'');
        req.setMethod('GET');
        
        req.setHeader('Authorization', ws.Authorization__c);
       
        System.debug(LoggingLevel.info, 'urlEndpoint : ' + urlEndpoint);
        System.debug(LoggingLevel.info, 'PRGDebug : Envoi requête...');
        
        HttpResponse resp= new HttpResponse();
        req.setTimeout(60000);
        resp = http.send(req);
        System.debug(LoggingLevel.info, 'PRGDebug : resp.getStatusCode() : ' + resp.getStatusCode());
        
        if(resp.getStatusCode()==200)
        {
           system.debug(LoggingLevel.info, 'BodyDebug :' + resp.getBody());
            message= 'ok ! '+ string.valueof(resp.getBody());
            if(typeAlerte == 'Tension batterie basse'){
                JSonLOwBat = JSONLowBattery.parse(resp.getBody());
                //JSONLowBattery r = JSONLowBattery.parse(resp.getBody());
                //system.debug('PRGDebug :' + JSonLOwBat.batteryMilliVolts.value_Z );
                //system.debug('PRGDebug :' + JSonLOwBat);
                alert.Tension_Batterie_2H_Update__c    = JSonLOwBat.tensionBatterie2H; 
                alert.Nb_Demarrages_12H_Update__c      = JSonLOwBat.nbDemarrage12H;
                alert.Charge_Alternateur_Update__c      = JSonLOwBat.chargeAlternateur;
                //alert.Dernier_Etat_Moteur_Update__c		= JSonLOwBat.engineStates.value;  
                
				if ('On'.equalsIgnoreCase(JSonLOwBat.engineStates.value)) {
					alert.Dernier_Etat_Moteur_Update__c		= 'Allumé';
				} else if ('Off'.equalsIgnoreCase(JSonLOwBat.engineStates.value)) {
					alert.Dernier_Etat_Moteur_Update__c		= 'Eteint';
				}
                
                alert.Date_Dernier_Etat_Moteur_Update__c= JSonLOwBat.engineStates.dateTime_Z;        
                alert.Niveau_Batterie_Actuel_Update__c =   JSonLOwBat.batteryMilliVolts.value_Z /1000 ; 
                alert.Temperature_Exterieure_Update__c =  JSonLOwBat.temperatureExterieure;
                alert.Nb_Kilometres_12H_Update__c = JSonLOwBat.nbKilometres12H;
                alert.Code_defaut_alternateur_update__c = JSonLOwBat.codeDefautAlternateur;
                alert.Vitesse_Du_Vehicule_Update__c = JSonLOwBat.vitesseKmh;
                alert.Occurrences__c = JSonLOwBat.occurrences;
                System.debug(LoggingLevel.info, 'nbOccurrences : ' + JSonLOwBat.occurrences);
                UPDATE alert; 
                
            } else if(typeAlerte == 'Voyant moteur'){
                System.debug(LoggingLevel.info,'Res Body : ' + resp.getBody());
                JSONEngineLightData lightData = JSONEngineLightData.parse(resp.getBody());                
                
                if(lightData != null) {
                    alert.voyant_moteur_sujet_Update__c = lightData.subject; 
                	alert.voyant_moteur_description_Update__c = lightData.description;
                    //alert.Occurrences__c = lightData.occurrences;
                    DateTime startDate = alert.DateTime_Alerte__c;
                    if(alert.DateTime_Alerte__c == null){                        
                        startDate = alert.CreatedDate;
                    }
                    // DateTime endDate = DateTime.now();
                    // calculer le nombre de jours/heures/minutes entre startDate & endDate
                    String dateDiff = dateDifference(startDate);
                    System.debug(LoggingLevel.info, 'dateDiff : ' + dateDiff);
                    
                    alert.Voyant_moteur_allume_depuis__c = dateDiff;                    
                	if(lightData.faultCodes != null){
                	 	alert.voyant_moteur_protocole_Update__c = lightData.faultCodes.protocol;
                        if(lightData.faultCodes.checkEngineLightIsOn != null && lightData.faultCodes.checkEngineLightIsOn){                            
                            alert.Voyant_moteur_allume_depuis_update__c = dateDiff;
                        }else if(lightData.faultCodes.stopIsOn != null && lightData.faultCodes.stopIsOn){
                            alert.Voyant_moteur_allume_depuis_update__c = dateDiff;
                        }else{
                            alert.Voyant_moteur_allume_depuis_update__c = 'Voyant éteint'; 
                        }
            		}
                    alert.Occurrences__c = lightData.occurrences;
                	System.debug(LoggingLevel.info, 'light occurrences : ' + lightData.occurrences);
                	UPDATE alert;
                }                
            }else if(typeAlerte == 'Coupure basse pression'){
                System.debug(LoggingLevel.info,'Res Body : ' + resp.getBody());
                JSONLowPressureCutOffA01 lowPressureData = JSONLowPressureCutOffA01.parse(resp.getBody());                
                
                if(lowPressureData != null) {
                    alert.sujet_Update__c = lowPressureData.subject; 
                	alert.description_Update__c = lowPressureData.description;                    
                    alert.Occurrences__c = lowPressureData.occurrences;
                	System.debug(LoggingLevel.info, 'low pressure occurrences : ' + lowPressureData.occurrences);
                	UPDATE alert;
                }                     
        	}
              
        } 
        else {
            system.debug(LoggingLevel.info, 'PRGDebug : Error response code different de 200' );
            message= string.valueof(resp.getStatusCode()); 
        }
                
        return  message;
    }
    
    public static String dateDifference(DateTime startDate){
        
        String result = '';
        
        DateTime endDate = DateTime.now();
        Long dt1Long = startDate.getTime();
        Long dt2Long = endDate.getTime();
        Long milliseconds = dt2Long - dt1Long;
        
        Long nbDays = milliseconds / (24*60*60*1000);
        if(nbDays > 0){
            result += nbDays + 'j ';
        }
        
        dt1Long = startDate.addDays((Integer)nbDays).getTime();
        milliseconds = dt2Long - dt1Long;
        
        Long nbHours = milliseconds / (60*60*1000);
        if(nbHours > 0){
            result += nbHours + 'h ';
        }
        
        dt1Long = startDate.addDays((Integer)nbDays).addHours((Integer)nbHours).getTime();
        milliseconds = dt2Long - dt1Long;
        
        Long nbMinutes = milliseconds / (60*1000);
        if(nbMinutes > 0){
            result += ' ' + nbMinutes + 'mn';
        }else if(milliseconds > 0 ){
            result += ' ' + 1 + 'mn';
        }
        
        return result;
    }
    
}