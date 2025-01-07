public class CallR_SMSService  implements Schedulable
{
    //Send SMS Method using CALLR WebService 
	@future (callout=true)
	public Static Void sendSMS(String SMS_Recipient, String SMS_Sender, String SMS_Message, String CaseId) 
    {
		String Endpoint = 'https://api.callr.com/rest/v1.1/sms';
        String UserName = 'petitforestieroffice_1';
        String Password = 'Rugby2019*';
        Blob HeaderValue = Blob.valueOf(UserName + ':' + Password);
        String AuthorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(HeaderValue);
        Map<String, String> DataToJson = new Map<String, String>();
 		String SMS_RecipientFormatted;
        if(SMS_Recipient.substring(0,1) == '0' && SMS_Recipient.substring(1,2) != '0')
        {
            SMS_RecipientFormatted = '+33' + SMS_Recipient.substring(1,SMS_Recipient.length());
        	//SMS_RecipientFormatted = '+34' + SMS_Recipient.substring(1,SMS_Recipient.length());
        	//SMS_RecipientFormatted = '+212' + SMS_Recipient.substring(1,SMS_Recipient.length());
        }
        else if (SMS_Recipient.substring(0,1) == '0' && SMS_Recipient.substring(1,2) == '0')
        {

        	SMS_RecipientFormatted =  SMS_Recipient;
        }
        else if (SMS_Recipient.substring(0,1) == '+' )
        {

        	SMS_RecipientFormatted =  SMS_Recipient;
        }
        else
        {
            SMS_RecipientFormatted = '+33' + SMS_Recipient;
        	//SMS_RecipientFormatted = '+34' + SMS_Recipient;
        	//SMS_RecipientFormatted = '+212' + SMS_Recipient;
        }
        //DataToJson.put('SMS_Recipient', SMS_Recipient);
        DataToJson.put('SMS_Recipient', SMS_RecipientFormatted);
        DataToJson.put('SMS_Sender', SMS_Sender);
        DataToJson.put('SMS_Message', SMS_Message);
        String Body = buildJson(DataToJson);
        System.debug('Body :  ' + Body);
        Http http = new Http();
        HttpRequest Req = new HttpRequest();
        Req.setEndpoint(Endpoint);
        Req.setMethod('POST');
        Req.setHeader('Content-Type','application/json');
        Req.setHeader('Authorization', AuthorizationHeader);
        Req.setBody(body);
        HttpResponse Resp= new HttpResponse();
        Req.setTimeout(60000);
        Resp = http.send(Req);
        System.debug('Status Code : '+String.valueOf(Resp.getStatusCode()));
        
        if(Resp.getStatusCode()==200)
        {
            String ResponseBody = Resp.getBody();
            System.debug('ResponseBody ( JSON ) ' + ResponseBody);
            System.debug(Resp.getStatus());
            if(CaseId !='test')
            {
            	List<Case> CaseRecord = [SELECT id, CaseNumber, SMS_Sent__c FROM Case WHERE id = :CaseId Limit 1];
            	CaseRecord[0].SMS_Sent__c = true ;
            	update CaseRecord;
            }
        }
        else
        {
            System.debug(Resp.getStatus());
        } 
	}
    
    //Send SMS Method using CALLR WebService 
	@future (callout=true)
	public Static Void sendSMS(String SMS_Recipient, String SMS_Sender, String SMS_Message, String CaseId, String EventId ) 
    {
		String Endpoint = 'https://api.callr.com/rest/v1.1/sms';
        String UserName = 'petitforestieroffice_1';
        String Password = 'Rugby2019*';
        Blob HeaderValue = Blob.valueOf(UserName + ':' + Password);
        String AuthorizationHeader = 'BASIC ' +EncodingUtil.base64Encode(HeaderValue);
        Map<String, String> DataToJson = new Map<String, String>();
        String SMS_RecipientFormatted;
        if(SMS_Recipient.substring(0,1) == '0' && SMS_Recipient.substring(1,2) != '0')
        {
            //SMS_RecipientFormatted = '+33' + SMS_Recipient.substring(1,SMS_Recipient.length());
        	SMS_RecipientFormatted = '+34' + SMS_Recipient.substring(1,SMS_Recipient.length());
        	//SMS_RecipientFormatted = '+212' + SMS_Recipient.substring(1,SMS_Recipient.length());
            //SMS_RecipientFormatted = '+44' + SMS_Recipient;

        }
        else if (SMS_Recipient.substring(0,1) == '0' && SMS_Recipient.substring(1,2) == '0')
        {

        	SMS_RecipientFormatted =  SMS_Recipient;
        }
        else if (SMS_Recipient.substring(0,1) == '+' )
        {

        	SMS_RecipientFormatted =  SMS_Recipient;
        }
        else
        {
            //SMS_RecipientFormatted = '+33' + SMS_Recipient;
        	SMS_RecipientFormatted = '+34' + SMS_Recipient;
        	//SMS_RecipientFormatted = '+212' + SMS_Recipient;
        	//SMS_RecipientFormatted = '+44' + SMS_Recipient;
        }

        
        //DataToJson.put('SMS_Recipient', SMS_Recipient);
        DataToJson.put('SMS_Recipient', SMS_RecipientFormatted);
        DataToJson.put('SMS_Sender', SMS_Sender);
        DataToJson.put('SMS_Message', SMS_Message);
        String Body = buildJson(DataToJson);
        System.debug('Body :  ' + Body);
        Http http = new Http();
        HttpRequest Req = new HttpRequest();
        Req.setEndpoint(Endpoint);
        Req.setMethod('POST');
        Req.setHeader('Content-Type','application/json');
        Req.setHeader('Authorization', AuthorizationHeader);
        Req.setBody(body);
        HttpResponse Resp= new HttpResponse();
        Req.setTimeout(60000);
        Resp = http.send(Req);
        System.debug('Status Code : '+String.valueOf(Resp.getStatusCode()));
        
        if(Resp.getStatusCode()==200)
        {
            String ResponseBody = Resp.getBody();
            System.debug('ResponseBody ( JSON ) ' + ResponseBody);
            System.debug(Resp.getStatus());
            if(CaseId !='test')
            {
            	List<Case> CaseRecord = [SELECT id, CaseNumber, SMS_Sent__c FROM Case WHERE id = :CaseId Limit 1];
            	CaseRecord[0].SMS_Sent__c = true ;
            	update CaseRecord;
            }
            else
            {
                List<Event> EventRecord = [SELECT id,Titre__c, SMS_de_rappel_envoye__c FROM Event WHERE id = :EventId Limit 1];
            	if(EventRecord.size()>0)
                {EventRecord[0].SMS_de_rappel_envoye__c = true ;
            	//EventRecord[0].Titre__c +=  ' Num : ' + SMS_RecipientFormatted ;
            	update EventRecord;}
                     
            }
            
        }
        else
        {
        	System.debug(Resp.getStatus());
        } 
	}
 
    //Flow Method
    @InvocableMethod(label='CallR Service : Send SMS' description='CallR Service : Send SMS' category='WorkOrder')
    public static Void sendSMS_FromFlow (List<FlowParams> FlowParams) 
    {
		//scheduleFromFlow(FlowParams[0].SMS_Recipient, FlowParams[0].SMS_Sender, FlowParams[0].SMS_Message, FlowParams[0].SMS_DateTime, FlowParams[0].SecondsToAdd, FlowParams[0].EventId, FlowParams[0].CommercialMobilePhone);
		scheduleFromFlow(FlowParams[0].SMS_Recipient, FlowParams[0].SMS_Sender, FlowParams[0].SMS_Message, FlowParams[0].SMS_DateTime, FlowParams[0].SecondsToAdd, FlowParams[0].EventId);
    }
    
    //Flow Variables
    public class FlowParams 
    {
        @InvocableVariable(label='SMS Recipient' description='SMS Recipient' required=true)
        public String SMS_Recipient;
        @InvocableVariable(label='SMS Sender' description='SMS Sender' required=true)
        public String SMS_Sender;
        @InvocableVariable(label='SMS Message' description='SMS Message' required=true)
        public String SMS_Message;
        @InvocableVariable(label='Date/Heure : Optionel pour le calcule de la date/heure d\'envoi du SMS' description='Date/Heure : Optionel pour le calcule de la date/heure d\'envoi du SMS' required=false)
        public Datetime SMS_DateTime;
        @InvocableVariable(label='Nombre de secondes qu\'il faut ajouter ou soustraire' description='Nombre de secondes qu\'il faut ajouter ou soustraire' required=true)
        public String SecondsToAdd;
        @InvocableVariable(label='Id de l\'événement' description='Id de l\'événement' required=true)
        public String EventId;  
        //@InvocableVariable(label='Numéro de téléphone du commercial' description='Numéro de téléphone du commercial' required=true)
        //public String CommercialMobilePhone;  
    }
    
    //Generate Json File. The Json file is used on CALLR Webservice Request
    private static String buildJson(Map<String, String> DataToJson)
    {
		String Json = '{ ';
        Json += '"to" : "' + DataToJson.get('SMS_Recipient') + '",';
        Json += '"from" : "' + DataToJson.get('SMS_Sender') + '",';
        Json += '"body" : "' + DataToJson.get('SMS_Message') + '"}';
        return Json;
    }
    
    //Execute the schedule Action of the class
	public void execute(SchedulableContext SC) 
	{
        String TriggerId = SC.getTriggerId();
        String TriggerId15 = 'JobId_' + SC.getTriggerId().to15();
		List<Google_Callr_Services_Params__c> GoogleCallrServicesParamRecord = new List<Google_Callr_Services_Params__c> ();
		GoogleCallrServicesParamRecord = [SELECT  RecordId_1__c, RecordId_2__c, RecordId_3__c, Recipient_Phone__c, SMS_Message__c, SMS_Sender__c, SMSType__c, EventId__c from Google_Callr_Services_Params__c where MasterLabel__c = :TriggerId15];
        String DriverPhone = GoogleCallrServicesParamRecord[0].Recipient_Phone__c;
		String SMSSender = GoogleCallrServicesParamRecord[0].SMS_Sender__c;
		String SMSMessage =  GoogleCallrServicesParamRecord[0].SMS_Message__c;
		String CaseId =  GoogleCallrServicesParamRecord[0].RecordId_3__c;
		String EventId =  GoogleCallrServicesParamRecord[0].EventId__c;
        if(GoogleCallrServicesParamRecord[0].EventId__c != '')
        {
        	CallR_SMSService.sendSMS(DriverPhone, SMSSender, SMSMessage, CaseId, EventId ); 
        }
        else
        {
        	CallR_SMSService.sendSMS(DriverPhone, SMSSender, SMSMessage, CaseId ); 
        }
    }

    //Used to invoke the schedule job
    public static void scheduleThis(String argPass,String name, String Origine, String Destination, String RecordId_1, String RecordId_2, String RecordId_3, String DriverPhone, String SMS_Sender, String SMS_Message)
    {
        String cronExp;
        String SMSType;
        if ( 'Last Schedule'.equals( argPass ) ) 
        {
            Datetime dt = Datetime.now().addSeconds(40);  
			cronExp = dt.format('s m H d M \'?\' yyyy');
            SMSType = 'To Delete';
        } 
        else if ( 'Immediately'.equals( argPass ) )
        {
			Datetime dt = Datetime.now().addSeconds(40);  
			cronExp = dt.format('s m H d M \'?\' yyyy'); 
            SMSType = 'Immediately';
        }
        String ScheduledJobID  = System.schedule(name, cronExp, new CallR_SMSService());
        Google_Callr_Services_Params__c Google_Callr_Services_Param_Record = new Google_Callr_Services_Params__c(RecordId_1__c= RecordId_1, RecordId_2__c = RecordId_2, RecordId_3__c = RecordId_3, MasterLabel__c='JobId_'+ ScheduledJobID, Job_Id__c= ScheduledJobID, Origine_Param__c = Origine, Destination_Param__c = Destination, Recipient_Phone__c = DriverPhone, SMS_Message__c = SMS_Message, SMS_Sender__c = SMS_Sender, SMSType__c =  SMSType );
		insert Google_Callr_Services_Param_Record;
    }
    
    //Used to invoke the schedule job from salesforce flows
    @future (callout=true)
    //public static void scheduleFromFlow( String SMS_Recipient, String SMS_Sender, String SMS_Message, Datetime SMS_DateTime, String SecondsToAdd, String EventId, String CommercialMobilePhone)
    public static void scheduleFromFlow( String SMS_Recipient, String SMS_Sender, String SMS_Message, Datetime SMS_DateTime, String SecondsToAdd, String EventId)
    {		                   
		String cronExp;
        Datetime dt;
        Datetime dt2;
        dt2 = SMS_DateTime ;
        String CreationDate;
        if ( SMS_DateTime != Null && SecondsToAdd != '0' ) 
        {
            dt = SMS_DateTime.addSeconds(Integer.valueOf(SecondsToAdd));  
			cronExp = dt.format('s m H d M \'?\' yyyy');
        } 
        else 
        {
			//dt = SMS_DateTime;  
			dt = Datetime.now().addSeconds(40);  
			cronExp = dt.format('s m H d M \'?\' yyyy'); 
        }
        //String Var_Date = SMS_DateTime.day() + '/' + SMS_DateTime.month() + '/' + SMS_DateTime.year();
        String Var_Date = dt2.format('dd/MM/yyyy');
        //String Var_Time = String.valueOf(dt.time());
        String Var_Time = String.valueOf(SMS_DateTime.format('HH:mm'));
        //String SMS_Message_Event = SMS_Message +  ' ' + Var_Date + ' a las ' + Var_Time + '. Si necesita cancelar la visita, gracias por llamar al ' + CommercialMobilePhone ;
        String SMS_Message_Event = SMS_Message +  ' ' + Var_Date + ' a las ' + Var_Time + '. Si necesita cancelar la visita, gracias por llamarnos. Este es un mensaje generado automáticamente. Por favor, no conteste a este SMS.'  ;
        CreationDate = Datetime.now().formatGMT('dd-MM-yyyy\' \'HH:mm:ss');
        String ScheduledJobID  = System.schedule(getUUID(), cronExp, new CallR_SMSService());
        //String ScheduledJobID = '1';
        Google_Callr_Services_Params__c Google_Callr_Services_Param_Record = new Google_Callr_Services_Params__c(Creation_Date__c = CreationDate,  MasterLabel__c='JobId_'+ ScheduledJobID, Job_Id__c= ScheduledJobID, Recipient_Phone__c = SMS_Recipient, SMS_Message__c =  SMS_Message_Event, SMS_Sender__c = SMS_Sender, RecordId_3__c = 'test', EventId__c = EventId );
		insert Google_Callr_Services_Param_Record;
    }

    //Generate Unique Names. used on Schedule jobs Method
    public static String getUUID()
	{
		Blob b = Crypto.GenerateAESKey(128);
        String h = EncodingUtil.ConvertTohex(b);
        String guid = h.SubString(0,8)+ '_' + h.SubString(8,12) + '_' + h.SubString(12,16) + '_' + h.SubString(16,20) + '_' + h.substring(20);
        return guid;
    }

}