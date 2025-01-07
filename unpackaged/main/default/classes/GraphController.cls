public class GraphController {        

    //Source :https://sfdcbrewery.github.io/ChartJsSalesforceLightning/
    @auraEnabled
    public List<LineChartVar> myLineChartVarList;
    
    @auraEnabled
    public GraphBatteryData graphBatteryData;
    
    public class GraphBatteryData{
        public List<LineChartVar> myLineChartVarList;
        public List<LineChartVar> engineStartsList;
        public List<LineChartVar> engineLightsList;
        public List<LineChartVar> alarmsList;
        public List<LineChartVar> ambientAirTemperatureList;
        public Decimal maxValueVoltage;
        public Decimal thresholdVoltage;
        public String typeAlerte;
		public String dateTimeAlerte;
		public String xAxisMin;
		public String xAxisMax;
		public String xAxisMinLabel;
		public String xAxisMaxLabel;
		public Decimal minTemperature = null;
		public Decimal maxTemperature = null;
		public Decimal setPointValue = null;        
    }
    
    public class LineChartVar {
        string label;
        Decimal firstValue;
        string secondValue;       
        
        public LineChartVar(string a, Decimal b/*, integer c*/){
            label = a;
            firstValue = b;
            //secondValue = c;
        } 
        public LineChartVar(string a, string b/*, integer c*/){
            label = a;
            secondValue = b;
        }
    }    
   
    @AuraEnabled
    public static string NewRefreshLowBatteryEvolution(string precord, string param){
        String message = '';
        List<LineChartVar> myLineChartVarList = new List<LineChartVar>();
        List<LineChartVar> engineStartsList = new List<LineChartVar>();
        List<LineChartVar> engineLightsList = new List<LineChartVar>();
        List<LineChartVar> alarmsList = new List<LineChartVar>();
        List<LineChartVar> ambientAirTemperatureList = new List<LineChartVar>();
        Decimal minTemperature = null;
        Decimal maxTemperature = null;
        Decimal setPointValue = null;
        
        GraphBatteryData graphBatteryData = new GraphBatteryData();
        TimeZone tz = UserInfo.getTimeZone();
        
        Alerte__c alert =[SELECT  id, Parc_Id__c ,
                           	Tension_Batterie_2H_Update__c,
                           	Nb_Demarrages_12H_Update__c ,
                           	Nb_Kilometres_12H_Update__c ,
                          	Niveau_Batterie_Actuel_Update__c,
                          	Temperature_Exterieure_Update__c,
                           	Charge_Alternateur_Update__c,
                           	Date_Dernier_Etat_Moteur_Update__c,                          
                          	CreatedDate,
                          	Type_De_Batterie__c,
                          	Statut_du_vehicule__c,
                          	parc__r.name,
                          	recordTypeId,
                          	DateTime_Alerte__c,
                          	Code_Alarme__c
                          	//Type_Alerte__c
                            FROM alerte__c where id= :precord LIMIT 1 ];
        
        String parcId = alert.parc__r.name;        
        System.debug(LoggingLevel.info, 'Asset name  : ' + parcId);  
        
        RecordType RecordType = [select Id, name from RecordType where id =: alert.recordTypeId ];
        String typeAlerte = RecordType.name;
        System.debug(LoggingLevel.info, 'typeAlerte  : ' + typeAlerte);  
        
        String AlertVehiculeName =EncodingUtil.urlEncode(parcId,'UTF-8');
        DateTime dateCreationAlert = alert.CreatedDate;
		if(alert.DateTime_Alerte__c != null){
            dateCreationAlert = alert.DateTime_Alerte__c;
        }        
        
        DateTime startDate = DateTime.now();
        Integer diff = 2;
        if(typeAlerte == 'Coupure basse pression'){
        	//diff = 24; // pour les alarmes CBP 24h de plage
        }
        if(param == 'live'){
            diff = 2;
        }else if(param == '12h'){
            diff = 12;
        }else if(param == '6h'){
            diff = 6;
        }else if(param == '3h'){
            diff = 3;
        }else{
            if(alert.DateTime_Alerte__c != null){
                //startDate = alert.DateTime_Alerte__c.addSeconds(1);
                startDate = alert.DateTime_Alerte__c;
            }else{
                startDate = alert.CreatedDate;
            }            
        }
        
        DateTime endDateGraph = startDate.addMinutes(1);
        DateTime startDateGraph = endDateGraph.addHours(-diff);
        
        String dateDebutGraph = '';
        
        String AlerteDate= string.valueof((endDateGraph.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')));
               AlerteDate= EncodingUtil.urlEncode(AlerteDate,'UTF-8');
        String AlerteDate2= string.valueof((startDateGraph.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'')));
               AlerteDate2= EncodingUtil.urlEncode(AlerteDate2,'UTF-8');

        String sbx = UserInfo.getUserName().substringAfterLast('.');
		System.debug(LoggingLevel.info, 'sandbox : ' + sbx);        

		WebserviceTelematicsData__c ws = [Select name, Endpoint__c, Authorization__c, Environnement__c, Sandbox__c 
                                  FROM WebserviceTelematicsData__c limit 1];
        if(Test.isRunningTest()) {
            ws = [Select name, Endpoint__c, Authorization__c, Environnement__c, Sandbox__c 
                                  FROM WebserviceTelematicsData__c WHERE Sandbox__c = 'infra' limit 1];
        }              
        Http http = new Http();
        if(typeAlerte == 'Tension batterie basse'){
            
            HttpRequest req = new HttpRequest();
            
            string urlEndpoint = ws.Endpoint__c + '/battery/voltages?pfVehicleId=';        
            req.setEndpoint(urlEndPoint+AlertVehiculeName+'&fromDate='+AlerteDate2+''+'&toDate='+AlerteDate+'');        
            req.setHeader('Authorization', ws.Authorization__c);
           
            System.debug(LoggingLevel.info, 'urlEndpoint : ' + urlEndpoint);
            System.debug(LoggingLevel.info, 'PRGDebug : Envoi requête...');
                    
            req.setMethod('GET');
            
            HttpResponse resp = new HttpResponse();
            req.setTimeout(60000);
            resp = http.send(req);
    
            if(resp.getStatusCode()==200)
            {
               message= 'ok ! '+ string.valueof(resp.getBody());
              List< JSONBatteryVoltage> r=  JSONBatteryVoltage.parse(resp.getBody());
                boolean alertPointSet = false;
                for(JSONBatteryVoltage j :r){
                    //String dateFormat = j.dateTime_Z.format('dd/MM/yyyy HH:mm:ss', tz.toString());
                    //String dateFormat = j.dateTime_Z.format('HH:mm:ss', tz.toString());
                    String dateFormat = j.dateTime_Z.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX', tz.toString());
                    myLineChartVarList.add(new LineChartVar(dateFormat, j.value/1000.0));                                        
                } 
            } 
            else {
                message= string.valueof(resp.getStatusCode()); 
            }
                        
        }else if(typeAlerte == 'Voyant moteur'){
            // Get check engine Lights data
            HttpRequest reqLights = new HttpRequest();
            string urlEndpointLights = ws.Endpoint__c + '/faultCodes/engineLights?pfVehicleId=';        
            reqLights.setEndpoint(urlEndpointLights+AlertVehiculeName+'&fromDate='+AlerteDate2+''+'&toDate='+AlerteDate+'');        
            reqLights.setHeader('Authorization', ws.Authorization__c);                
            reqLights.setMethod('GET');
            reqLights.setTimeout(30000);
            
            HttpResponse respLights= new HttpResponse();       
            respLights = http.send(reqLights);
    
            if(respLights.getStatusCode() == 200)
            {
               message= 'ok ! '+ string.valueof(respLights.getBody());
              List< JSONFaultCodes> r =  JSONFaultCodes.parse(respLights.getBody());
                for(JSONFaultCodes j : r){
                    String dateFormat = j.dateTime_Z.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX', tz.toString());
                    //String dateFormat = j.dateTime_Z.format('HH:mm:ss', tz.toString());
					Boolean lightValue = false;

                    if(j.protocol == 'passenger'){
                    	lightValue = j.checkEngineLightIsOn;
                    }else if(j.protocol == 'j1939'){
                    	lightValue = j.stopIsOn;
                    }
					String lightOnOff = 'Off';
                    if(lightValue == true){
                    	lightOnOff = 'On';
                    }
                    engineLightsList.add(new LineChartVar(dateFormat, lightOnOff));
                } 
            } 
            else {
                message= string.valueof(respLights.getStatusCode()); 
            }
        }else if(typeAlerte == 'Coupure basse pression'){
            // Get alarms data
            HttpRequest reqAlarms = new HttpRequest();
            String alarmCode = 'A01/P01';
            if(alert.Code_Alarme__c != null){
                alarmCode = alert.Code_Alarme__c;
            }
            string urlEndpointAlarms = ws.Endpoint__c + '/alarms/code?alarmCode=' + alarmCode + '&pfVehicleId=';        
            reqAlarms.setEndpoint(urlEndpointAlarms+AlertVehiculeName+'&fromDate='+AlerteDate2+''+'&toDate='+AlerteDate+'');        
            reqAlarms.setHeader('Authorization', ws.Authorization__c);                
            reqAlarms.setMethod('GET');
            reqAlarms.setTimeout(30000);
            
            HttpResponse respAlarms= new HttpResponse();       
            respAlarms = http.send(reqAlarms);
    
            if(respAlarms.getStatusCode() == 200)
            {
               message= 'ok ! '+ string.valueof(respAlarms.getBody());
              List< JSONAlarms> r =  JSONAlarms.parse(respAlarms.getBody());
                for(JSONAlarms j : r){
                    String dateFormat = j.dateTime_Z.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX', tz.toString());
                    //String dateFormat = j.dateTime_Z.format('HH:mm:ss', tz.toString());					
					String lightOnOff = 'On';
                    
                    alarmsList.add(new LineChartVar(dateFormat, lightOnOff));
                } 
            } 
            else {
                message= string.valueof(respAlarms.getStatusCode()); 
            }
        }
        
        
        if(typeAlerte == 'Coupure basse pression') {
            // Temperature ambiante pour les alertes Coupure Basse Pression
            HttpRequest reqTemperature = new HttpRequest();
            string urlEndpointTemperature = ws.Endpoint__c + '/ambientAirTemperatureMilliC/byVehicleBetweenDates?pfVehicleId=';        
            reqTemperature.setEndpoint(urlEndpointTemperature+AlertVehiculeName+'&fromDate='+AlerteDate2+''+'&toDate='+AlerteDate+'');        
            reqTemperature.setHeader('Authorization', ws.Authorization__c);                
            reqTemperature.setMethod('GET');
            reqTemperature.setTimeout(30000);
            
            HttpResponse respTemperature= new HttpResponse();       
            respTemperature = http.send(reqTemperature);
    
            if(respTemperature.getStatusCode() == 200 && !Test.isRunningTest())
            {
               	message= 'ok ! '+ string.valueof(respTemperature.getBody());
              	List< JSONAmbientAirTemperature> r =  JSONAmbientAirTemperature.parse(respTemperature.getBody());
                DateTime lastDate = null;
                for(JSONAmbientAirTemperature j : r){                    
                    String dateFormat = j.dateTime_Z.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX', tz.toString()); 
                    ambientAirTemperatureList.add(new LineChartVar(dateFormat, j.value/1000));
                    if(maxTemperature == null || j.value/1000 > maxTemperature){
                        maxTemperature = j.value/1000;
                    }
                    if(minTemperature == null || j.value/1000 < minTemperature){
                        minTemperature = j.value/1000;
                    }
                    /*if(lastDate == null){
                        ambientAirTemperatureList.add(new LineChartVar(dateFormat, j.value/1000.0));
                        lastDate = j.dateTime_Z;
                    }else{
                        Long milliseconds = j.dateTime_Z.getTime() - lastDate.getTime();
                        if(milliseconds > (20*60*1000)){
                            ambientAirTemperatureList.add(new LineChartVar(dateFormat, j.value/1000.0));
                            lastDate = j.dateTime_Z;
                        }
                    }*/
                                      
                }
            } 
            else {
                message= string.valueof(respTemperature.getStatusCode()); 
            }
        
        	if(string.Isempty(message)  || message=='null'){ message='0';}
            
            // Récupérer la valeur du point de consigne
            HttpRequest reqSetPoint = new HttpRequest();
            string urlEndpointSetPoint = ws.Endpoint__c + '/setPoint/lastByDate?pfVehicleId=';        
            reqSetPoint.setEndpoint(urlEndpointSetPoint+AlertVehiculeName+'&fromDate='+AlerteDate2+''+'&toDate='+AlerteDate+'');        
            reqSetPoint.setHeader('Authorization', ws.Authorization__c);                
            reqSetPoint.setMethod('GET');
            reqSetPoint.setTimeout(30000);
            
            HttpResponse respSetPoint= new HttpResponse();       
            respSetPoint = http.send(reqSetPoint);
    
            if(respSetPoint.getStatusCode() == 200 && !Test.isRunningTest()){
                System.debug(LoggingLevel.info, 'Setpoint : ' + respSetPoint.getBody());
                if(respSetPoint.getBody() != null && respSetPoint.getBody() != ''){
                    setPointValue = Double.valueOf(respSetPoint.getBody());
                }
                
            }else {
                message= string.valueof(respTemperature.getStatusCode()); 
            }

        } else {
            HttpRequest reqEngine = new HttpRequest();
            string urlEndpointEngine = ws.Endpoint__c + '/engineStates/starts?pfVehicleId=';        
            reqEngine.setEndpoint(urlEndpointEngine+AlertVehiculeName+'&fromDate='+AlerteDate2+''+'&toDate='+AlerteDate+'');        
            reqEngine.setHeader('Authorization', ws.Authorization__c);                
            reqEngine.setMethod('GET');
            reqEngine.setTimeout(30000);
            
            HttpResponse respEngine= new HttpResponse();       
            respEngine = http.send(reqEngine);
    
            if(respEngine.getStatusCode()==200 &&  !Test.isRunningTest())
            {
               message= 'ok ! '+ string.valueof(respEngine.getBody());
              List< JSONEngineState> r =  JSONEngineState.parse(respEngine.getBody());
                for(JSONEngineState j : r){                    
                    String dateFormat = j.dateTime_Z.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX', tz.toString());
                    //String dateFormat = j.dateTime_Z.format('HH:mm:ss', tz.toString());
                    engineStartsList.add(new LineChartVar(dateFormat, j.value));                    
                } 
            } 
            else {
                message= string.valueof(respEngine.getStatusCode()); 
            }
        
        	if(string.Isempty(message)  || message=='null'){ message='0';}
        } 
                    
        graphBatteryData.myLineChartVarList = myLineChartVarList;
        graphBatteryData.engineStartsList = engineStartsList;
        graphBatteryData.typeAlerte = typeAlerte;
        graphBatteryData.engineLightsList = engineLightsList;
        graphBatteryData.alarmsList = alarmsList;
        graphBatteryData.ambientAirTemperatureList = ambientAirTemperatureList;
        graphBatteryData.dateTimeAlerte = dateCreationAlert.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX', tz.toString());
        graphBatteryData.xAxisMin = startDateGraph.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX', tz.toString());
        graphBatteryData.xAxisMax = endDateGraph.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX', tz.toString());
        graphBatteryData.xAxisMinLabel = startDateGraph.format('dd/MM/yyyy HH:mm', tz.toString());
        graphBatteryData.xAxisMaxLabel = endDateGraph.format('dd/MM/yyyy HH:mm', tz.toString());
        if(minTemperature != null){
            graphBatteryData.minTemperature = minTemperature;
        }
        
        if(maxTemperature != null){
            graphBatteryData.maxTemperature = maxTemperature;
        }
        if(setPointValue != null){
            graphBatteryData.setPointValue = setPointValue;
        }
                        
        if(alert.Type_De_Batterie__c == '24 Volts'){ // 24 Volts
        	graphBatteryData.maxValueVoltage = 35; 	
        	graphBatteryData.thresholdVoltage = 21; 	
        	if(alert.Statut_du_vehicule__c == 'MOTEUR_TOURNANT_VEHICULE_ROULANT'){
                graphBatteryData.thresholdVoltage = 24;
            }
        } else{ // 12 Volts
        	graphBatteryData.maxValueVoltage = 20;
        	graphBatteryData.thresholdVoltage = 10.5;
            if(alert.Statut_du_vehicule__c == 'MOTEUR_TOURNANT_VEHICULE_ROULANT'){
                graphBatteryData.thresholdVoltage = 12;
            }
        }
                
        return JSON.Serialize(graphBatteryData);
    }

}